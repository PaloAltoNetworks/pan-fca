package main

import (
    "fmt"
    "io"
    "io/ioutil"
    "os"
    "regexp"
    "strings"
    "time"
    "flag"

    "golang.org/x/crypto/ssh"
)

// Various prompts.
var (
    P1 *regexp.Regexp
    P2 *regexp.Regexp
    P3 *regexp.Regexp
)

func init() {
    P1 = regexp.MustCompile(`[a-zA-Z][a-zA-Z0-9\._\-]+@[a-zA-Z][a-zA-Z0-9\._\-]+> `)
    P2 = regexp.MustCompile(`[a-zA-Z][a-zA-Z0-9\._\-]+@[a-zA-Z][a-zA-Z0-9\._\-]+# `)
    P3 = regexp.MustCompile(`(Enter|Confirm) password\s+:\s+?`)
}

// Load Argument variables.
//var hostname = flag.String("host", "", "Panorama or Firewall IP/FQDN")
//var username = flag.String("user", "", "Username of admin for PANOS")




// Globals to handle I/O.
var (
    stdin io.Writer
    stdout io.Reader
    buf [65 * 1024]byte
)

// ReadTo reads from stdout until the desired prompt is encountered.
func ReadTo(prompt *regexp.Regexp) (string, error) {
    var i int

    for {
        n, err := stdout.Read(buf[i:])
        if n > 0 {
            os.Stdout.Write(buf[i:i + n])
        }
        if err != nil {
            return "", err
        }
        i += n
        if prompt.Find(buf[:i]) != nil {
            return string(buf[:i]), nil
        }
    }
}

// Perform user initialization.
func panosInit() error {
    var err error
    passPtr := flag.String("password", "foo", "Password of addmin for PANOS")
    userPtr := flag.String("username", "bar", "Username of admin for PANOS")
    hostPtr := flag.String("host", "", "Panorama or Firewall IP/FQDN")
    keyPtr := flag.String("key", "", "Key File Name")



    // Load Argument variables.
    //hostname := flag.String("host", "", "Panorama or Firewall IP/FQDN")
    //username := flag.String("user", "admin", "Username of admin for PANOS")
    //password := flag.String("password", "", "Password of addmin for PANOS")
    flag.Parse()

    fmt.Println("username:", *userPtr)
    fmt.Println("password:", *passPtr)
    fmt.Println("hostname:", *hostPtr)

    // Sanity check input.
    if len(os.Args) == 1 || os.Args[1] == "-h" || os.Args[1] == "--help" {
        u := []string{
            fmt.Sprintf("Usage: %s <key_file>", *keyPtr),
            "",
            "This will connect to a PAN-OS NGFW and perform initial config:",
            "",
            " * Adds the user as a superuser (if not the admin user)",
            " * Sets the user's password",
            " * Commit",
            "",
            "The following environment variables are required:",
            "",
            " * PANOS_HOSTNAME",
            " * PANOS_USERNAME",
            " * PANOS_PASSWORD",
        }
        for i := range u {
            fmt.Printf("%s\n", u[i])
        }
        os.Exit(0)
    }

    // Read in the ssh key file.
    data, err := ioutil.ReadFile(*keyPtr)
    if err != nil {
        return fmt.Errorf("Failed to read SSH key file %q: %s", os.Args[1], err)
    }

    signer, err := ssh.ParsePrivateKey(data)
    if err != nil {
        return fmt.Errorf("Failed to parse private key: %s", err)
    }

    useSshKey := ssh.PublicKeys(signer)

    // Configure and open the ssh connection.
    config := &ssh.ClientConfig{
        User: "admin",
        Auth: []ssh.AuthMethod{
            useSshKey,
        },
        HostKeyCallback: ssh.InsecureIgnoreHostKey(),
    }

    client, err := ssh.Dial("tcp", fmt.Sprintf("%s:22", *hostPtr), config)
    if err != nil {
        return fmt.Errorf("Failed dial: %s", err)
    }
    defer client.Close()

    session, err := client.NewSession()
    if err != nil {
        return fmt.Errorf("Failed to create session: %s", err)
    }
    defer session.Close()

    modes := ssh.TerminalModes{
        ssh.ECHO: 0,
        ssh.TTY_OP_ISPEED: 14400,
        ssh.TTY_OP_OSPEED: 14400,
    }

    if err = session.RequestPty("vt100", 80, 80, modes); err != nil {
        return fmt.Errorf("pty request failed: %s", err)
    }

    // Get input/output pipes for the ssh connection.
    stdin, err = session.StdinPipe()
    if err != nil {
        return fmt.Errorf("setup stdin err: %s", err)
    }

    stdout, err = session.StdoutPipe()
    if err != nil {
        return fmt.Errorf("setup stdout err: %s", err)
    }

    // Invoke a shell on the remote host.
    if err = session.Start("/bin/sh"); err != nil {
        return fmt.Errorf("failed session.Start: %s", err)
    }

    // Perform initial config.
    ok := true
    commands := []struct{
        Send string
        Expect *regexp.Regexp
        Validation string
        OmitIfAdmin bool
    }{
        {"", P1, "", false},
        {"set cli pager off", P1, "", false},
        {"show system info", P1, "", false},
        {"configure", P2, "", false},
        {fmt.Sprintf("set mgt-config users %s permissions role-based superuser yes", *userPtr), P2, "", true},
        {fmt.Sprintf("set mgt-config users %s password", *userPtr), P3, "", false},
        {*passPtr, P3, "", false},
        {*passPtr, P2, "", false},
        {"commit description 'initial config'", P2, "Configuration committed successfully", false},
        {"exit", P1, "", false},
        {"exit", nil, "", false},
    }

    for _, cmd := range commands {
        if cmd.OmitIfAdmin && *userPtr == "admin" {
            continue
        }
        if cmd.Send != "" {
            stdin.Write([]byte(cmd.Send + "\n"))
        }
        if cmd.Expect != nil {
            out, err := ReadTo(cmd.Expect)
            if err != nil {
                return fmt.Errorf("Error in %q: %s", cmd.Send, err)
            }
            if cmd.Validation != "" {
                ok = ok && strings.Contains(out, cmd.Validation)
            }
            // Delay slightly before sending passwords.
            if cmd.Expect == P3 {
                time.Sleep(1 * time.Second)
            }
        } else {
            fmt.Printf("exit\n")
            session.Wait()
        }
    }

    // Completed successfully.
    return nil
}

func main() {
    if err := panosInit(); err != nil {
        fmt.Printf("\nFailed initial config: %s\n", err)
        os.Exit(1)
    }
    fmt.Printf("\nConfig initialization successful")
}
