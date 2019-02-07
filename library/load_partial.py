# -*- coding: utf-8 -*-
## Developed by Uriah Bojorquez
from PyQt5.QtWidgets import QMainWindow, QApplication, QFileDialog, QMessageBox, QSizePolicy, QDialog
from PyQt5.QtGui import QColor, QPalette
from PyQt5 import QtCore
from qt_iron_skillet_ui import Ui_Dialog as IRONSKILLET
from qt_config_ui_panorama import Ui_Dialog as PANORAMA
from qt_config_ui import Ui_Dialog as PANOS
from qt_lcp_ui import Ui_MainWindow
from lxml import etree as lxml
from functools import partial
import collections
import webbrowser
import requests
import paramiko
import tempfile
import socket
import sys
import re
import os

# suppress warnings from requests library
requests.packages.urllib3.disable_warnings()

##############################################
# IRON SKILLET
##############################################
class IronSkillet(QtCore.QThread):
    values_iron_skillet = QtCore.pyqtSignal(dict)
    done = QtCore.pyqtSignal(bool)

    def __init__(self, elements, os, api, url, file, from_vsys, to_vsys, parent=None):
        super(IronSkillet, self).__init__(parent)
        self.isRunning = True
        self.elements = elements
        self.os = os
        self.api = api
        self.url = url
        self.file = file
        self.from_vsys = from_vsys
        self.to_vsys = to_vsys

    def run(self):
        elements = {}

        done = False

        values_iron_skillet = {
            'element': None,
            'result': None,
            'response': None,
            'error': None,
            'pb_value': 0,
            'done': False
        }

        # PANORAMA
        if self.os == 'Panorama':

            # init dict
            elements['system'] = "<load><config><partial><from>{file}</from><from-xpath>/config/devices/entry[@name='localhost.localdomain']/deviceconfig/system</from-xpath><to-xpath>/config/devices/entry[@name='localhost.localdomain']/deviceconfig/system</to-xpath><mode>merge</mode></partial></config></load>".format(file=self.file),
            elements['settings'] = "<load><config><partial><from>{file}</from><from-xpath>/config/devices/entry[@name='localhost.localdomain']/deviceconfig/setting</from-xpath><to-xpath>/config/devices/entry[@name='localhost.localdomain']/deviceconfig/setting</to-xpath><mode>merge</mode></partial></config></load>".format(file=self.file),
            elements['log settings'] = "<load><config><partial><from>{file}</from><from-xpath>/config/panorama/log-settings</from-xpath><to-xpath>/config/panorama/log-settings</to-xpath><mode>merge</mode></partial></config></load>".format(file=self.file),
            elements['template'] = "<load><config><partial><from>{file}</from><from-xpath>/config/devices/entry[@name='localhost.localdomain']/template</from-xpath><to-xpath>/config/devices/entry[@name='localhost.localdomain']/template</to-xpath><mode>merge</mode></partial></config></load>".format(file=self.file),
            elements['device group'] = "<load><config><partial><from>{file}</from><from-xpath>/config/devices/entry[@name='localhost.localdomain']/device-group</from-xpath><to-xpath>/config/devices/entry[@name='localhost.localdomain']/device-group</to-xpath><mode>merge</mode></partial></config></load>".format(file=self.file),
            elements['shared'] = "<load><config><partial><from>{file}</from><from-xpath>/config/shared</from-xpath><to-xpath>/config/shared</to-xpath><mode>merge</mode></partial></config></load>".format(file=self.file),
            elements['log collector'] = "<load><config><partial><from>{file}</from><from-xpath>/config/devices/entry[@name='localhost.localdomain']/log-collector-group</from-xpath><to-xpath>/config/devices/entry[@name='localhost.localdomain']/log-collector-group</to-xpath><mode>merge</mode></partial></config></load>".format(file=self.file),

            for key in self.elements.keys():
                if self.elements[key]:

                    values = {
                        'type': 'op',
                        'key': self.api,
                        'cmd': elements[key]
                    }

                    values_iron_skillet['result'], values_iron_skillet['response'], values_iron_skillet['error'] = self._api_request(values)
                    values_iron_skillet['element'] = key
                    values_iron_skillet['pb_value'] += 14.29
                    values_iron_skillet['done'] = False
                    self.values_iron_skillet.emit(values_iron_skillet)
            done = True

        # PAN-OS
        else:

            # init dict
            elements['log settings'] = "<load><config><partial><from>{file}</from><from-xpath>/config/shared/log-settings</from-xpath><to-xpath>/config/shared/log-settings</to-xpath><mode>merge</mode></partial></config></load>".format(file=self.file),
            elements['tag'] = "<load><config><partial><from>{file}</from><from-xpath>/config/devices/entry[@name='localhost.localdomain']/vsys/entry[@name='{from_vsys}']/tag</from-xpath><to-xpath>/config/devices/entry[@name='localhost.localdomain']/vsys/entry[@name='{to_vsys}']/tag</to-xpath><mode>merge</mode></partial></config></load>".format(file=self.file, from_vsys=self.from_vsys, to_vsys=self.to_vsys),
            elements['system'] = "<load><config><partial><from>{file}</from><from-xpath>/config/devices/entry[@name='localhost.localdomain']/deviceconfig/system</from-xpath><to-xpath>/config/devices/entry[@name='localhost.localdomain']/deviceconfig/system</to-xpath><mode>merge</mode></partial></config></load>".format(file=self.file),
            elements['settings'] = "<load><config><partial><from>{file}</from><from-xpath>/config/devices/entry[@name='localhost.localdomain']/deviceconfig/setting</from-xpath><to-xpath>/config/devices/entry[@name='localhost.localdomain']/deviceconfig/setting</to-xpath><mode>merge</mode></partial></config></load>".format(file=self.file),
            elements['address'] = "<load><config><partial><from>{file}</from><from-xpath>/config/devices/entry[@name='localhost.localdomain']/vsys/entry[@name='{from_vsys}']/address</from-xpath><to-xpath>/config/devices/entry[@name='localhost.localdomain']/vsys/entry[@name='{to_vsys}']/address</to-xpath><mode>merge</mode></partial></config></load>".format(file=self.file, from_vsys=self.from_vsys, to_vsys=self.to_vsys),
            elements['external list'] = "<load><config><partial><from>{file}</from><from-xpath>/config/devices/entry[@name='localhost.localdomain']/vsys/entry[@name='vsys1']/external-list</from-xpath><to-xpath>/config/devices/entry[@name='localhost.localdomain']/vsys/entry[@name='vsys1']/external-list</to-xpath><mode>merge</mode></partial></config></load>".format(file=self.file, from_vsys=self.from_vsys,   to_vsys=self.to_vsys),
            elements['profiles'] = "<load><config><partial><from>{file}</from><from-xpath>/config/devices/entry[@name='localhost.localdomain']/vsys/entry[@name='vsys1']/profiles</from-xpath><to-xpath>/config/devices/entry[@name='localhost.localdomain']/vsys/entry[@name='vsys1']/profiles</to-xpath><mode>merge</mode></partial></config></load>".format(file=self.file, from_vsys=self.from_vsys, to_vsys=self.to_vsys),
            elements['profile group'] = "<load><config><partial><from>{file}</from><from-xpath>/config/devices/entry[@name='localhost.localdomain']/vsys/entry[@name='vsys1']/profile-group</from-xpath><to-xpath>/config/devices/entry[@name='localhost.localdomain']/vsys/entry[@name='vsys1']/profile-group</to-xpath><mode>merge</mode></partial></config></load>".format(file=self.file, from_vsys=self.from_vsys, to_vsys=self.to_vsys),
            elements['rulebase'] = "<load><config><partial><from>{file}</from><from-xpath>/config/devices/entry[@name='localhost.localdomain']/vsys/entry[@name='vsys1']/rulebase</from-xpath><to-xpath>/config/devices/entry[@name='localhost.localdomain']/vsys/entry[@name='vsys1']/rulebase</to-xpath><mode>merge</mode></partial></config></load>".format(file=self.file, from_vsys=self.from_vsys, to_vsys=self.to_vsys),
            elements['zone protection'] = "<load><config><partial><from>{file}</from><from-xpath>/config/devices/entry[@name='localhost.localdomain']/network/profiles/zone-protection-profile</from-xpath><to-xpath>/config/devices/entry[@name='localhost.localdomain']/network/profiles/zone-protection-profile</to-xpath><mode>merge</mode></partial></config></load>".format(file=self.file)
            elements['reports'] = "<load><config><partial><from>{file}</from><from-xpath>/config/shared/reports</from-xpath><to-xpath>/config/shared/reports</to-xpath><mode>merge</mode></partial></config></load>".format(file=self.file),
            elements['report group'] = "<load><config><partial><from>{file}</from><from-xpath>/config/shared/report-group</from-xpath><to-xpath>/config/shared/report-group</to-xpath><mode>merge</mode></partial></config></load>".format(file=self.file),
            elements['email schedule'] = "<load><config><partial><from>{file}</from><from-xpath>/config/shared/email-scheduler</from-xpath><to-xpath>/config/shared/email-scheduler</to-xpath><mode>merge</mode></partial></config></load>".format(file=self.file),

            for key in self.elements.keys():
                if self.elements[key]:

                    values = {
                        'type': 'op',
                        'key': self.api,
                        'cmd': elements[key]
                    }

                    values_iron_skillet['result'], values_iron_skillet['response'], values_iron_skillet['error'] = self._api_request(values)
                    values_iron_skillet['element'] = key
                    values_iron_skillet['pb_value'] += 7.7
                    values_iron_skillet['done'] = False
                    self.values_iron_skillet.emit(values_iron_skillet)

            done = True

        self.done.emit(done)

    ##############################################
    # API REQUEST
    ##############################################
    def _api_request(self, values):
        """
        API request driver
        """

        try:
            return True, requests.post(self.url, values, verify=False, timeout=10).text, None
        except requests.exceptions.ConnectionError as error_api:
            return False, 'Error connecting to {ip} - Check IP Address'.format(ip=self.url), error_api
        except requests.exceptions.Timeout as error_timeout:
            return None, 'Connection to {ip} timed out, please try again'.format(ip=self.url), error_timeout


##############################################
# API REQUEST
##############################################
class APIRequest(QtCore.QThread):
    api_values = QtCore.pyqtSignal(dict)

    def __init__(self, api, url, cmd, parent=None):
        super(APIRequest, self).__init__(parent)
        self.isRunning = True
        self.api = api
        self.url = url
        self.cmd = cmd

    def run(self):

        api_values = {
            'result': None,
            'response': None,
            'error': None
        }

        # build API rquest
        values = {
            'type': 'op',
            'key': self.api,
            'cmd': self.cmd
        }

        # make API call
        api_values['result'], api_values['response'], api_values['error'] = self._api_request(values)

        self.api_values.emit(api_values)

    ##############################################
    # API REQUEST
    ##############################################
    def _api_request(self, values):
        """
        API request driver
        """

        try:
            return True, requests.post(self.url, values, verify=False, timeout=10).text, None
        except requests.exceptions.ConnectionError as error_api:
            return False, 'Error connecting to {ip} - Check IP Address'.format(ip=self.url), error_api
        except requests.exceptions.Timeout as error_timeout:
            return None, 'Connection to {ip} timed out, please try again'.format(ip=self.url), error_timeout


##############################################
# SETUP SSH
##############################################
class SetupSSH(QtCore.QThread):
    output = QtCore.pyqtSignal(str)

    def __init__(self, ip, user, password, parent=None):
        super(SetupSSH, self).__init__(parent)
        self.is_running = True
        self.ip = ip
        self.user = user
        self.password = password

    def run(self):
        self.command = 'show config saved \t'
        output = self.connect_driver()

        self.output.emit(output)

    ##############################################################################
    # SETUP SSH
    ##############################################################################
    def setup_ssh(self):
        conn = paramiko.SSHClient()
        conn.load_system_host_keys()
        conn.set_missing_host_key_policy(paramiko.AutoAddPolicy())

        try:
            conn.connect(self.ip, username=self.user, password=self.password)
        except paramiko.SSHException as e:
            self.show_critical_error(['Error connecting to {ip}'.format(ip=self.ip), e])
            return False

        return conn

    ##############################################################################
    # EXECUTE SSH COMMAND
    ##############################################################################
    def execute_shh(self, ssh_connection):
        shell = ssh_connection.invoke_shell()

        while not shell.recv_ready():
            pass

        shell.send('set cli pager off\n')

        while not shell.recv_ready():
            pass

        shell.send(self.command)
        prompt = ''
        results = ''

        while '<value>' not in prompt:
            results += shell.recv(4096).decode('utf-8')
            prompt = results.strip()

        return results

    ##############################################################################
    # DRIVER FUNCTION
    ##############################################################################
    def connect_driver(self):
        ssh_obj = self.setup_ssh()
        ssh_data = self.execute_shh(ssh_obj)

        ssh_obj.close()

        return ssh_data

    ##############################################
    # SHOW CRITICAL ERROR
    ##############################################
    def show_critical_error(self, message_list):

        message = '''
        <p>
        {message}
        <br>
        Error: {error}
        </p>
        '''.format(message=message_list[0], error=message_list[1])

        result = QMessageBox.critical(self, 'ERROR', message, QMessageBox.Abort, QMessageBox.Retry)

        # Abort
        if result == QMessageBox.Abort:
            self.close()

        # Retry
        else:

            # set error flag to True -- implies error
            self._flag_error = True
            return

##############################################
# FILL COMBO BOXES
##############################################
class ToComboBoxes(QtCore.QThread):

    combo_box_values = QtCore.pyqtSignal(dict)

    def __init__(self, api, url, parent=None):
        super(ToComboBoxes, self).__init__(parent)
        self.is_running = True
        self.api = api
        self.url = url

    def run(self):

        combo_box_values = {
            'result': None,
            'response': None,
            'error': None
        }

        values = {
            'type': 'op',
            'key': self.api,
            'cmd': '<show><config><saved>running-config.xml</saved></config></show>'
        }

        combo_box_values['result'], combo_box_values['response'], combo_box_values['error'] = self.api_request(values)

        self.combo_box_values.emit(combo_box_values)

    ##############################################
    # API REQUEST
    ##############################################
    def api_request(self, values):
        """
        API request driver
        """

        try:
            return True, requests.post(self.url, values, verify=False, timeout=10).text, None
        except requests.exceptions.ConnectionError as error_api:
            return False, 'Error connecting to {ip} - Check IP Address'.format(ip=self.url), error_api
        except requests.exceptions.Timeout as error_timeout:
            return None, 'Connection to {ip} timed out, please try again'.format(ip=self.url), error_timeout


##############################################
# CONNECT THREAD
##############################################
class ConnectThread(QtCore.QThread):

    connect_values = QtCore.pyqtSignal(dict) # define new Signal

    def __init__(self, ip, user, password, parent=None,):
        super(ConnectThread, self).__init__(parent)
        self.is_running = True
        self.ip = ip
        self.user = user
        self.password = password

    def run(self):

        self.valid = False

        connect_values = {
            'api': None,
            'ip': None,
            'user': None,
            'password': None,
            'url': None,
            'result': None,
            'response': None,
            'error': None
        }

        # IP
        try:
            socket.gethostbyname(self.ip)
        except socket.gaierror as os_error_ip:
            print(os_error_ip)
            connect_values['response'] = "Unable to Connect or Invalid IP address given"
            connect_values['error'] = os_error_ip
        else:

            self.url = 'https://{ip}/api'.format(ip=self.ip)
            connect_values['ip'] = self.ip
            connect_values['url'] = self.url

            # Username
            try:
                if self.user.isspace() or len(self.user) is 0:
                    raise AttributeError('invalid username')
            except AttributeError as error_user:
                connect_values['response'] = 'The Username field is blank'
                connect_values['error'] = error_user
            else:
                connect_values['user'] = self.user

                # Password
                try:
                    if self.password.isspace() or len(self.password) is 0:
                        raise AttributeError('invalid password')
                except AttributeError as error_password:
                    connect_values['response'] = 'The Password field is blank'
                    connect_values['error'] = error_password
                else:
                    connect_values['password'] = self.password

                   # all fields valid
                    self.valid = True

            if self.valid:

                try:
                    # get API key
                    connect_values['result'], connect_values['response'], connect_values['error'] = self.keygen()

                    if connect_values['result']:
                        connect_values['api'] = connect_values['response']
                except lxml.XMLSyntaxError as error_xml:
                    connect_values['response'] = "Is this a FW/Panorama IP/Hostname?"
                    connect_values['error'] = error_xml


        # emit signal values
        self.connect_values.emit(connect_values)

    ##############################################
    # API DRIVER
    ##############################################
    def keygen(self):
        """
        Get API key
        """

        values = {'type': 'keygen', 'user': self.user, 'password': self.password}
        result, response, error = self.api_request(values)

        try:
            # if API call was successful
            if result is True:
                return True, lxml.fromstring(response).find('.//key').text, None

            # if timeout
            elif result is None:
                raise requests.Timeout

            # if connection error
            else:
                raise ValueError('check IP address')

        # connectino error
        except (IndexError, ValueError) as error_keygen:
            return False, 'Error obtaining API key from {ip}'.format(ip=self.ip), error_keygen

        # if error raised finding <key> in response
        except AttributeError:
            return False, 'Error obtaining API key from {ip}'.format(ip=self.ip), 'check credentials'

        # if timeout
        except requests.Timeout as error_timeout:
            return False, 'Connection to {ip} timed out, please try again'.format(ip=self.ip), error_timeout

    ##############################################
    # API REQUEST
    ##############################################
    def api_request(self, values):
        """
        API request driver
        """

        try:
            return True, requests.post(self.url, values, verify=False, timeout=10).text, None
        except requests.exceptions.ConnectionError as error_api:
            return False, 'Error connecting to {ip} - Check IP Address'.format(ip=self.ip), error_api
        except requests.exceptions.Timeout as error_timeout:
            return None, 'Connection to {ip} timed out, please try again'.format(ip=self.ip), error_timeout

    ##############################################
    # SHOW CRITICAL ERROR
    ##############################################
    def show_critical_error(self, message_list):

        message = '''
        <p>
        {message}
        <br>
        Error: {error}
        </p>
        '''.format(message=message_list[0], error=message_list[1])

        result = QMessageBox.critical(self, 'ERROR', message, QMessageBox.Abort, QMessageBox.Retry)

        # Abort
        if result == QMessageBox.Abort:
            self.close()

        # Retry
        else:

            # set error flag to True -- implies error
            self._flag_error = True
            return


##############################################
# MAIN WINDOW
##############################################
class LoadPartialMainWindow(QMainWindow):
    def __init__(self):

        # setup main window
        QMainWindow.__init__(self)
        self.ui = Ui_MainWindow()
        self.ui.setupUi(self)

        # variables
        self._is_output = '<html>'

        self._model = None
        self._api = None
        self._from = None
        self._to = None
        self._from_file = None
        self._load_config_partial = '<load><config><partial><from>{file}</from><from-xpath>{xpath_from}{obj_from}</from-xpath><to-xpath>{xpath_to}{obj_to}</to-xpath><mode>merge</mode></partial></config></load>'

        # iron skillet variables
        self._iron_skillet_panos = collections.OrderedDict()
        self._iron_skillet_panos['log settings'] = True
        self._iron_skillet_panos['tag'] = True
        self._iron_skillet_panos['system'] = True
        self._iron_skillet_panos['settings'] = True
        self._iron_skillet_panos['address'] = True
        self._iron_skillet_panos['external list'] = True
        self._iron_skillet_panos['profiles'] = True
        self._iron_skillet_panos['profile group'] = True
        self._iron_skillet_panos['rulebase'] = True
        self._iron_skillet_panos['zone protection'] = True
        self._iron_skillet_panos['reports'] = True
        self._iron_skillet_panos['report group'] = True
        self._iron_skillet_panos['email schedule'] = True


        self._iron_skillet_panorama = collections.OrderedDict()
        self._iron_skillet_panorama['system'] = True,
        self._iron_skillet_panorama['settings'] = True,
        self._iron_skillet_panorama['log settings'] = True,
        self._iron_skillet_panorama['template'] = True,
        self._iron_skillet_panorama['device group'] = True,
        self._iron_skillet_panorama['shared'] = True,
        self._iron_skillet_panorama['log collector'] = True


        ##############################################
        # BUTTON EVENTS/TRIGGERS
        ##############################################
        self.ui.button_iron_skillet.clicked.connect(self._iron_skillet)
        self.ui.button_quit.clicked.connect(self.close)
        self.ui.button_connect.clicked.connect(self._connect)
        self.ui.button_import.clicked.connect(self._import)
        self.ui.button_ao.clicked.connect(partial(self._load_objects, 'address'))
        self.ui.button_ag.clicked.connect(partial(self._load_objects, 'address-group'))
        self.ui.button_so.clicked.connect(partial(self._load_objects, 'service'))
        self.ui.button_sg.clicked.connect(partial(self._load_objects, 'service-group'))
        self.ui.button_tags.clicked.connect(partial(self._load_objects, 'tag'))
        self.ui.button_security.clicked.connect(partial(self._load_rulebase, 'security'))
        self.ui.button_nat.clicked.connect(partial(self._load_rulebase, 'nat'))
        self.ui.button_reports.clicked.connect(partial(self._load_reports, 'reports'))
        self.ui.button_report_groups.clicked.connect(partial(self._load_reports, 'report-group'))

        ##############################################
        # COMBO BOX EVENTS
        ##############################################
        self.ui.combo_file.currentIndexChanged.connect(self._update_file_selected)
        self.ui.combo_from_dg.currentIndexChanged.connect(self._reset_flags_buttons)
        self.ui.combo_from_rulebase.currentIndexChanged.connect(self._reset_flags_buttons)
        self.ui.combo_to_dg.currentIndexChanged.connect(self._reset_flags_buttons)
        self.ui.combo_to_rulebase.currentIndexChanged.connect(self._reset_flags_buttons)
        self.ui.combo_from_vsys.currentIndexChanged.connect(self._reset_flags_buttons)
        self.ui.combo_to_vsys.currentIndexChanged.connect(self._reset_flags_buttons)

    ############################################################################
    # LOAD REPORTS
    ############################################################################
    def _load_reports(self, obj):

        self.obj = obj
        self.ui.progress_bar.setValue(0)
        self.ui.label_status.setText('Merging {obj}...'.format(obj=obj))

        # validate user input
        if self._validate_user_input() is not True:
            return

        self._xpath_from = None
        self._xpath_to = None

        #########################################
        # FROM
        #########################################
        # build xpaths - if Panoramma
        if len(self.ui.combo_from_dg.currentText()) > 1:

            # shared
            if self.ui.combo_from_dg.currentText() == 'Shared':
                self._xpath_from = '/config/shared/'

            # DG
            else:
                self._xpath_from = "/config/devices/entry[@name='localhost.localdomain']/device-group/entry[@name='{dg}']/".format(dg=self.ui.combo_from_dg.currentText())

        # PAN-OS
        else:
            self._xpath_from = '/config/shared/'

        #########################################
        # TO
        #########################################
        # Panorama
        if len(self.ui.combo_to_dg.currentText()) > 1:

            # Shared
            if self.ui.combo_to_dg.currentText() == 'Shared':
                self._xpath_to = '/config/shared/'
            # DG
            else:
                self._xpath_to = "/config/devices/entry[@name='localhost.localdomain']/device-group/entry[@name='{dg}']/".format(dg=self.ui.combo_to_dg.currentText())

        # PAN-OS
        else:
            self._xpath_to = '/config/shared/'

        # build out load config partial command
        cmd = self._load_config_partial.format(
            file=self._from_file,
            xpath_from=self._xpath_from,
            xpath_to=self._xpath_to,
            obj_from=self.obj,
            obj_to=self.obj
        )

        cmd_output = 'load config partial from {file} from-xpath {xpath_from}{obj_from} to-xpath {xpath_to}{obj_to} mode merge'.format(
            file=self._from_file,
            xpath_from=self._xpath_from,
            xpath_to=self._xpath_to,
            obj_from=self.obj,
            obj_to=self.obj
        )

        # output to text browser
        self.ui.text_out.clear()
        self.ui.text_out.append('> Type: <b><font color="yellow">{type}</font></b>'.format(type=self.obj))
        self.ui.text_out.append('> Executing the following command...')
        self.ui.text_out.append('\n')
        self.ui.text_out.append(cmd_output)
        self.ui.text_out.append('\n')

        self.ui.progress_bar.setValue(50)
        self.connect_api_thread = APIRequest(parent=None, api=self._api, url=self._url, cmd=cmd)
        self.connect_api_thread.start()
        self.connect_api_thread.api_values.connect(self._connect_values_thread)


    ############################################################################
    # IRON SKILLET
    ############################################################################
    def _iron_skillet(self):

        # check user input
        if not self._validate_user_input():
            return

        # check parameters are not null
        if self._from_file== 'Select a File' or len(self.ui.combo_file.currentText()) < 1:
               self._show_critical_error(['Error!', 'Select a "From" file'])
               return


        self.ui.progress_bar.setValue(0)
        self.ui.label_status.setText('Iron Skillet...')
        self.ui.text_out.clear()
        self.ui.text_out.append('> Starting Iron Skillet...')

        d = QDialog()
        ui = PANORAMA() if self._model == 'Panorama' else PANOS()
        ui.setupUi(d)
        d.show()
        resp = d.exec_()

        self._process_iron_skillet = True if resp == QDialog.Accepted else False

        # if they hit 'cancel' -- break out of function
        if not self._process_iron_skillet:
            return

        # PANORAMA
        if self._model == 'Panorama':
            self._iron_skillet_panorama['system'] = False if not ui.checkbox_system.isChecked() else True
            self._iron_skillet_panorama['settings'] = False if not ui.checkbox_setting.isChecked() else True
            self._iron_skillet_panorama['log settings'] = False if not ui.checkbox_log.isChecked() else True
            self._iron_skillet_panorama['template'] = False if not ui.checkbox_template.isChecked() else True
            self._iron_skillet_panorama['device group'] = False if not ui.checkbox_dg.isChecked() else True
            self._iron_skillet_panorama['shared'] = False if not ui.checkbox_shared.isChecked() else True
            self._iron_skillet_panorama['log collector'] = False if not ui.checkbox_log_collector.isChecked() else True

            self.connect_thread_iron_skillet = IronSkillet(parent=None, elements=self._iron_skillet_panorama, os='Panorama', api=self._api, url=self._url, file=self._from_file, from_vsys=self.ui.combo_from_vsys.currentText(), to_vsys=self.ui.combo_to_vsys.currentText())
            self.connect_thread_iron_skillet.start()
            self.connect_thread_iron_skillet.values_iron_skillet.connect(self._iron_skillet_output)
            self.connect_thread_iron_skillet.done.connect(self._print_iron_skillet)

        # PAN-OS
        else:
            self._iron_skillet_panos['address'] = False if not ui.checkbox_address.isChecked() else True
            self._iron_skillet_panos['email schedule'] = False if not ui.checkbox_email_schedule.isChecked() else True
            self._iron_skillet_panos['external list'] = False if not ui.checkbox_ext_list.isChecked() else True
            self._iron_skillet_panos['log settings'] = False if not ui.checkbox_log.isChecked() else True
            self._iron_skillet_panos['profile group'] = False if not ui.checkbox_profile_group.isChecked() else True
            self._iron_skillet_panos['profiles'] = False if not ui.checkbox_profiles.isChecked() else True
            self._iron_skillet_panos['report group'] = False if not ui.checkbox_report_groups.isChecked() else True
            self._iron_skillet_panos['reports'] = False if not ui.checkbox_reports.isChecked() else True
            self._iron_skillet_panos['rulebase'] = False if not ui.checkbox_rulebase.isChecked() else True
            self._iron_skillet_panos['settings'] = False if not ui.checkbox_setting.isChecked() else True
            self._iron_skillet_panos['system'] = False if not ui.checkbox_system.isChecked() else True
            self._iron_skillet_panos['tag'] = False if not ui.checkbox_tag.isChecked() else True
            self._iron_skillet_panos['zone protection'] = False if not ui.checkbox_zone_protection.isChecked() else True

            self.connect_thread_iron_skillet = IronSkillet(parent=None, elements=self._iron_skillet_panos, os='PAN-OS', api=self._api, url=self._url, file=self._from_file, from_vsys=self.ui.combo_from_vsys.currentText(), to_vsys=self.ui.combo_to_vsys.currentText())
            self.connect_thread_iron_skillet.start()
            self.connect_thread_iron_skillet.values_iron_skillet.connect(self._iron_skillet_output)
            self.connect_thread_iron_skillet.done.connect(self._print_iron_skillet)


    ##############################################
    # IRON SKILLET OUTPUT
    ##############################################
    def _iron_skillet_output(self, output):

        element = '> {}'.format(output['element'])
        self.ui.text_out.append(element)
        self._is_output += '<h2>{}</h2><ul>'.format(element)

        xml = lxml.fromstring(output['response'])
        for line in xml.xpath('.//line'):
            response = '        > {}'.format(line.text)
            self.ui.text_out.append(response)
            self._is_output += '<li>{}</li>'.format(line.text)

        self.ui.text_out.append('')
        self._is_output += '</ul>'
        self.ui.progress_bar.setValue(output['pb_value'])

    ##############################################
    # IRON SKILLET DONE
    ##############################################
    def _print_iron_skillet(self, flag):
        self._is_output += '</html>'
        self.ui.progress_bar.setValue(100)

        d = QDialog()
        ui = IRONSKILLET()
        ui.setupUi(d)
        resp = d.exec_()

        if resp == QDialog.Accepted:
            tmp = tempfile.NamedTemporaryFile(delete=True)
            path = tmp.name + '.html'

            f = open(path, 'w')
            f.write('<html><body>{}</body></html>'.format(self._is_output))
            f.close()
            webbrowser.open('file://' + path)

    ##############################################
    # RESET FLAGS
    ##############################################
    def _reset_flags(self):
        self._flag_tags = False
        self._flag_address_objects = False
        self._flag_address_groups = False
        self._flag_service_objects = False
        self._flag_service_groups = False
        self._flag_connect_success = False

    ##############################################
    # RESET FLAGS and BUTTONS
    ##############################################
    def _reset_flags_buttons(self):
        self._reset_flags()
        self._reset_button_color()

    ##############################################
    # CONNECT
    ##############################################
    def _connect(self):
        # get/set IP and credentials (validate parameters)
        valid = False

        self.ui.progress_bar.setValue(0)
        self.ui.label_status.setText('Connecting, retrieving running-config, loading saved configs...')

        # clear all combo boxes
        self.ui.text_out.clear()
        self.ui.combo_to_dg.clear()
        self.ui.combo_from_dg.clear()
        self.ui.combo_to_vsys.clear()
        self.ui.combo_from_vsys.clear()
        self.ui.combo_from_rulebase.clear()
        self.ui.combo_to_rulebase.clear()

        # reset all flags & flags
        self._reset_flags_buttons()

        ####
        self.connect_thread = ConnectThread(parent=None, ip=self.ui.line_ip.text(), user=self.ui.line_user.text(), password=self.ui.line_password.text())
        self.connect_thread.start()
        self.connect_thread.connect_values.connect(self._set_connect_values)

    ##############################################
    # SET CONNECT VALUES
    ##############################################
    def _set_connect_values(self, values):

        if values['result']:
            self._api = values['api']
            self._ip = values['ip']
            self._user = values['user']
            self._password = values['password']
            self._url = values['url']
            self.ui.button_connect.setStyleSheet('background-color: green; color:white;')
            self.ui.button_connect.setText('Connected to: {ip}'.format(ip=self._ip))
            self.ui.progress_bar.setValue(25)

            # trigger functions to fill combo boxes
            self._system_info()

            self.connect_thread_combo_boxes = ToComboBoxes(parent=None, api=self._api, url=self._url)
            self.connect_thread_combo_boxes.start()
            self.connect_thread_combo_boxes.combo_box_values.connect(self._fill_to_combo_boxes)

            self.connect_thread_setup_ssh = SetupSSH(parent=None, ip=self._ip, user=self._user, password=self._password)
            self.connect_thread_setup_ssh.start()
            self.connect_thread_setup_ssh.output.connect(self._load_saved_configs)

        else:
            self.ui.button_connect.setStyleSheet('background-color: red; color:white;')
            self.ui.button_connect.setText('Connection Error: {ip}'.format(ip=values['ip']))
            self._show_critical_error([values['response'], values['error']])

    ##############################################
    # IMPORT CONFIG
    ##############################################
    def _import(self):

        # if model isn't set, return
        if self._model is None:
            return

        # prompt user for import file
        self._import_file, _ = QFileDialog.getOpenFileName(parent=None, caption="Import Local Config (XML)", directory=os.getcwd(), filter="XML files (*.xml)")

        # if cancelled
        if len(self._import_file) == 0:
            return

        self.ui.progress_bar.setValue(0)
        self.ui.progress_bar.setValue(10)
        self.ui.label_status.setText('Importing {file}'.format(file=self._import_file))

        try:
            with open(self._import_file, 'rb') as f:
                response = requests.post(
                    url=self._url + '/?type=import&category=configuration',
                    data={'key': self._api},
                    files={'file': f},
                    verify=False,
                    timeout=10).content

        # if any errors - display error message and return
        except (requests.ConnectionError, requests.ConnectTimeout, requests.HTTPError) as error_requests:
            self._show_critical_error(['Importing File', error_requests])
            return

        else:
            self.ui.progress_bar.setValue(50)

            # check if successful, if so, reload saved config files
            if lxml.fromstring(response).get('status') == 'success':
                self.ui.text_out.clear()
                self.ui.text_out.append('> {file} has been successfully imported!'.format(file=self._import_file))
                self.ui.text_out.append('> Refreshing...')
                self.ui.progress_bar.setValue(100)

                self.connect_thread_setup_ssh = SetupSSH(parent=None, ip=self._ip, user=self._user, password=self._password)
                self.connect_thread_setup_ssh.start()
                self.connect_thread_setup_ssh.output.connect(self._load_saved_configs)

            # if error, return
            else:
                self._show_critical_error(['Importing File', 'Unable to load {file}'.format(file=self._import_file)])
                return

    ##############################################
    # VALIDATE USER INPUT
    ##############################################
    def _validate_user_input(self):

        # did user select a file?
        if self.ui.combo_file.currentText() == 'Select a File':
            self._show_critical_error(['Error!', 'You must select a file!'])
            return

        # check if FROM Vsys and DG are None
        if len(self.ui.combo_from_vsys.currentText()) < 1 and len(self.ui.combo_from_dg.currentText()) < 1:
            return False

        # check if TO Vsys and DG are None
        if len(self.ui.combo_to_vsys.currentText()) < 1 and len(self.ui.combo_to_dg.currentText()) < 1:
            return False

        # validate model has been set
        if self._model is not None:
            return True
        else:
            return False

    ##############################################
    # BUILD XPATH
    ##############################################
    def _build_xpath(self):

        panorama = "/config/devices/entry[@name='localhost.localdomain']/device-group/entry[@name='{dg}']/"
        shared = '/config/shared/'
        vsys = "/config/devices/entry[@name='localhost.localdomain']/vsys/entry[@name='{vsys}']/"

        # init and clear out xpaths
        self._xpath_to = None
        self._xpath_from = None

        #########################################
        # FROM
        #########################################

        # Panorama
        if len(self.ui.combo_from_dg.currentText()) > 1 and len(self.ui.combo_from_rulebase.currentText()) > 1:

            # shared
            if self.ui.combo_from_dg.currentText() == 'Shared':
                try:
                    self._xpath_from = shared
                except KeyError:
                    self._show_critical_error(['Input Error', 'Select a valid "From" Rulebase'])
                    return

            # device group
            else:
                try:
                    self._xpath_from = panorama.format(dg=self.ui.combo_from_dg.currentText())
                except KeyError:
                    self._show_critical_error(['Input Error', 'Select a valid "From" Rulebase'])
                    return

        # PAN-OS (VSYS)
        elif len(self.ui.combo_from_vsys.currentText()) > 1:
            self._xpath_from = vsys.format(vsys=self.ui.combo_from_vsys.currentText())

        #########################################
        # TO
        #########################################

        # Panorama
        if len(self.ui.combo_to_dg.currentText()) > 1 and len(self.ui.combo_to_rulebase.currentText()) > 1:

            # shared
            if self.ui.combo_to_dg.currentText() == 'Shared':
                try:
                    self._xpath_to = shared
                except KeyError:
                    self._show_critical_error(['Input Error', 'Select a valid "TO" Rulebase'])
                    return

            # device group
            else:
                try:
                    self._xpath_to = panorama.format(dg=self.ui.combo_to_dg.currentText())
                except KeyError:
                    self._show_critical_error(['Input Error', 'Select a valid "TO" Rulebase'])
                    return

        # PAN-OS (VSYS)
        elif len(self.ui.combo_to_vsys.currentText()) > 1:
            self._xpath_to = vsys.format(vsys=self.ui.combo_to_vsys.currentText())

    ##############################################
    # LOAD RULEBASE
    ##############################################
    def _load_rulebase(self, rule):

        self.rule = rule
        self.ui.progress_bar.setValue(0)
        self.ui.label_status.setText('Merging {rule}...'.format(rule=self.rule))

        # validate user input
        if self._validate_user_input() is not True:
            return

        # valid rulebase?
        if self.ui.combo_from_rulebase.currentText() == 'Select Rulebase' or self.ui.combo_to_rulebase.currentText() == 'Select Rulebase':
            self._show_critical_error(['Error!', 'To/From Rulebase not selected'])
            return

        # should I prompt an info dialog?
        info = False
        info_msg = '<b>The following Objects/Groups have NOT been loaded:</b><ul>'

        # check flags
        if self._flag_tags is not True:
            info_msg += '<li>Tags</li>'
            info = True
        if self._flag_address_objects is not True:
            info_msg += '<li>Address Objects</li>'
            info = True
        if self._flag_address_groups is not True:
            info_msg += '<li>Address Groups</li>'
            info = True
        if self._flag_service_objects is not True:
            info_msg += '<li>Service Objects</li>'
            info = True
        if self._flag_service_groups is not True:
            info_msg += '<li>Service Groups</li>'
            info = True

        info_msg += '</ul>The command to add "{rule}" policies will still be executed; make sure to add the above Objects/Groups before committing (if necessary).<br>'.format(rule=rule)

        # prompt if True
        if info:
            # QMessageBox.information(self, 'Info', info_msg, QMessageBox.Ok)
            mbox = QMessageBox(self)
            mbox.setText(self.tr('Warning!'))
            mbox.setInformativeText(info_msg)
            mbox.resize(400, 200)
            mbox.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)
            mbox.show()

        # build xpaths
        self._build_xpath()

        # check rulebase
        from_rulebase = ''
        to_rulebase = ''

        rulebase = {
            'Pre Rulebase': 'pre-rulebase',
            'Post Rulebase': 'post-rulebase'
        }

        # from rulebase
        if len(self.ui.combo_from_rulebase.currentText()) > 1:
            from_rulebase += '{x}/{y}'.format(x=rulebase[self.ui.combo_from_rulebase.currentText()], y=self.rule)
        else:
            from_rulebase = 'rulebase/' + self.rule

        # to rulebase
        if len(self.ui.combo_to_rulebase.currentText()) > 1:
            to_rulebase += '{x}/{y}'.format(x=rulebase[self.ui.combo_to_rulebase.currentText()], y=self.rule)
        else:
            to_rulebase = 'rulebase/' + self.rule

        # build out load config partial command
        cmd = self._load_config_partial.format(
            file=self._from_file,
            xpath_from=self._xpath_from,
            xpath_to=self._xpath_to,
            obj_from=from_rulebase,
            obj_to=to_rulebase
        )

        cmd_output = 'load config partial from {file} from-xpath {xpath_from}{obj_from} to-xpath {xpath_to}{obj_to} mode merge'.format(
            file=self._from_file,
            xpath_from=self._xpath_from,
            xpath_to=self._xpath_to,
            obj_from=from_rulebase,
            obj_to=to_rulebase
        )

        # output to text browser
        self.ui.text_out.clear()
        self.ui.text_out.append('> Type: <b><font color="yellow">{rule}</font></b>'.format(rule=self.rule))
        self.ui.text_out.append('> Executing the following command...')
        self.ui.text_out.append('\n')
        self.ui.text_out.append(cmd_output)
        self.ui.text_out.append('\n')

        self.ui.progress_bar.setValue(50)
        self.connect_api_rule_thread = APIRequest(parent=None, api=self._api, url=self._url, cmd=cmd)
        self.connect_api_rule_thread.start()
        self.connect_api_rule_thread.api_values.connect(self._connect_rule_values_thread)

    ##############################################
    # CONNECT VALUES THREAD - RULES
    ##############################################
    def _connect_rule_values_thread(self, values):

        # convert to XML
        values['response'] = lxml.fromstring(values['response'])

        # if successful
        if values['response'].get('status') == 'success':
            self.ui.text_out.append('> <b>Status: <font color="green">{status}</font></b>'.format(status=values['response'].get('status')))
            self.ui.text_out.append('> {msg}'.format(msg=values['response'].xpath('.//line')[0].text))
            self._set_button_backgroud('green', self.rule)

        # if unsuccessful
        else:
            self.ui.text_out.append('> <b>Status: <font color="red">{status}</font></b>'.format(status=values['response'].get('status')))
            self.ui.text_out.append('> {msg}'.format(msg=values['response'].xpath('.//line')[0].text))
            self._set_button_backgroud('red', self.rule)

        self.ui.progress_bar.setValue(100)

    ##############################################
    # ADDRESS OBJECTS
    ##############################################
    def _load_objects(self, obj):

        self.obj = obj
        self.ui.progress_bar.setValue(0)
        self.ui.label_status.setText('Merging {obj}...'.format(obj=self.obj))

        # validate user input
        if self._validate_user_input() is not True:
            return

        obj_message = {
            'address': 'Address Objects',
            'address-group': 'Address Groups',
            'service': 'Service Objects',
            'service-group': 'Service Groups'
        }

        # should I prompt an info dialog?
        info = False
        info_msg = '<b>The following has been detected:</b><ul>'

        # check flags and warn user
        if self.obj != 'tag' and self._flag_tags is False:
            info = True
            info_msg += '<li>{obj} are being loaded before Tags</li>'.format(obj=obj_message[self.obj])

        # address groups before address objects?
        if self.obj == 'address-group' and self._flag_address_objects is False:
            info = True
            info_msg += '<li>Address Groups are being loaded before Address Objects</li>'

        # service gorups before service objects?
        if self.obj == 'service-group' and self._flag_service_objects is False:
            info = True
            info_msg += '<li>Service Groups are being loaded before Service Objects</li>'


        # prompt if True
        if info:
            info_msg += '</ul>The command to add "{obj}" will still be executed; make sure to add the above Objects before committing (if necessary).<br>'.format(obj=obj_message[obj])
            mbox = QMessageBox(self)
            mbox.setText(self.tr('Warning!'))
            mbox.setInformativeText(info_msg)
            mbox.resize(400, 200)
            mbox.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)
            mbox.show()

        # set flags
        if self.obj == 'tag':
            self._flag_tags = True
        elif self.obj == 'address':
            self._flag_address_objects = True
        elif self.obj == 'address-group':
            self._flag_address_groups = True
        elif self.obj == 'service':
            self._flag_service_objects = True
        elif self.obj == 'service-group':
            self._flag_service_groups = True

        # build out the xpaths
        self._build_xpath()

        # build out load config partial command
        cmd = self._load_config_partial.format(
            file=self._from_file,
            xpath_from=self._xpath_from,
            xpath_to=self._xpath_to,
            obj_from=self.obj,

            obj_to=self.obj
        )

        cmd_output = 'load config partial from {file} from-xpath {xpath_from}{obj_from} to-xpath {xpath_to}{obj_to} mode merge'.format(
            file=self._from_file,
            xpath_from=self._xpath_from,
            xpath_to=self._xpath_to,
            obj_from=self.obj,
            obj_to=self.obj
        )

        # output to text browser
        self.ui.text_out.clear()
        self.ui.text_out.append('> Type: <b><font color="yellow">{type}</font></b>'.format(type=obj))
        self.ui.text_out.append('> Executing the following command...')
        self.ui.text_out.append('\n')
        self.ui.text_out.append(cmd_output)
        self.ui.text_out.append('\n')

        self.ui.progress_bar.setValue(50)
        self.connect_api_thread = APIRequest(parent=None, api=self._api, url=self._url, cmd=cmd)
        self.connect_api_thread.start()
        self.connect_api_thread.api_values.connect(self._connect_values_thread)

    ##############################################
    # CONNECT VALUES THREAD - OBJECTS/GROUPS
    ##############################################
    def _connect_values_thread(self, values):

        if values['result'] is True:
            # convert to XML
            values['response'] = lxml.fromstring(values['response'])
        else:
            self._show_critical_error(['Slow Down!', values['response']])
            return

        # if successful
        if values['response'].get('status') == 'success':
            self.ui.text_out.append('> <b>Status: <font color="green">{status}</font></b>'.format(status=values['response'].get('status')))
            self.ui.text_out.append('> {msg}'.format(msg=values['response'].xpath('.//line')[0].text))
            self._set_button_backgroud('green', self.obj)

        # if unsuccessful
        else:
            self.ui.text_out.append('> <b>Status: <font color="red">{status}</font></b>'.format(status=values['response'].get('status')))
            self.ui.text_out.append('> {msg}'.format(msg=values['response'].xpath('.//line')[0].text))
            self._set_button_backgroud('red', self.obj)

        self.ui.progress_bar.setValue(100)

    ##############################################
    # SET BUTTON BACKGROUND COLOR
    ##############################################
    def _set_button_backgroud(self, color, button):

        if button == 'tag':
            self.ui.button_tags.setStyleSheet('background-color: {color}; color:white;'.format(color=color))

        elif button == 'address':
            self.ui.button_ao.setStyleSheet('background-color: {color}; color:white;'.format(color=color))

        elif button == 'address-group':
            self.ui.button_ag.setStyleSheet('background-color: {color}; color:white;'.format(color=color))

        elif button == 'service':
            self.ui.button_so.setStyleSheet('background-color: {color}; color:white;'.format(color=color))

        elif button == 'service-group':
            self.ui.button_sg.setStyleSheet('background-color: {color}; color:white;'.format(color=color))

        elif button == 'security':
            self.ui.button_security.setStyleSheet('background-color: {color}; color:white;'.format(color=color))

        elif button == 'nat':
            self.ui.button_nat.setStyleSheet('background-color: {color}; color:white;'.format(color=color))

        elif button == 'reports':
            self.ui.button_reports.setStyleSheet('background-color: {color}; color:white;'.format(color=color))

        elif button == 'report-group':
            self.ui.button_report_groups.setStyleSheet('background-color: {color}; color:white;'.format(color=color))


    ##############################################
    # RESET BUTTON COLOR
    ##############################################
    def _reset_button_color(self):
        self.ui.button_tags.setStyleSheet('color: white; background-color: rgb(53,53,53);')
        self.ui.button_ao.setStyleSheet('color: white; background-color: rgb(53,53,53);')
        self.ui.button_ag.setStyleSheet('color: white; background-color: rgb(53,53,53);')
        self.ui.button_so.setStyleSheet('color: white; background-color: rgb(53,53,53);')
        self.ui.button_sg.setStyleSheet('color: white; background-color: rgb(53,53,53);')
        self.ui.button_security.setStyleSheet('color: white; background-color: rgb(53,53,53);')
        self.ui.button_nat.setStyleSheet('color: white; background-color: rgb(53,53,53);')
        self.ui.button_reports.setStyleSheet('color: white; background-color: rgb(53,53,53);')
        self.ui.button_report_groups.setStyleSheet('color: white; background-color: rgb(53,53,53);')
        # self.ui.button_applications.setStyleSheet('color: white; background-color: rgb(53,53,53);')
        # self.ui.button_application_groups.setStyleSheet('color: white; background-color: rgb(53,53,53);')


    ##############################################
    # API REQUEST
    ##############################################
    def _update_file_selected(self):
        """
        Get the selected Saved Config
        Sets the "FROM" combo boxes: DG and/or VSYS
        """

        if self.ui.combo_file.currentText() == 'Select a File' or len(self.ui.combo_file.currentText()) < 1:
               return

        self.ui.progress_bar.setValue(0)
        self.ui.label_status.setText('Updating File selected...')

        self._from_file = self.ui.combo_file.currentText()

        # clear from DG and from VSYS
        self.ui.combo_from_dg.clear()
        self.ui.combo_from_vsys.clear()
        self.ui.combo_from_rulebase.clear()

        # reset all flags
        self._flag_tags = False
        self._flag_address_objects = False
        self._flag_address_groups = False
        self._flag_service_objects = False
        self._flag_service_groups = False

        # reset button colors
        self._reset_button_color()

        # get config file from selected text
        values = {
            'type': 'op',
            'key': self._api,
            'cmd': '<show><config><saved>{name}</saved></config></show>'.format(name=self._from_file),
        }

        result, response, error = self._api_request(values)

        # if successful
        if result is True and lxml.fromstring(response).get('status') == 'success':
            self._from_config = lxml.fromstring(response)
            self.ui.text_out.clear()
            self.ui.text_out.append('> "{name}" has been loaded!'.format(name=self._from_file))

        else:
            self.ui.text_out.clear()
            self.ui.text_out.append('> Error loading "{name}". Please try again.'.format(name=self._from_file))
            self.ui.text_out.append('> {error}'.format(error=error))
            self._from_config = False

        # if config obtained
        if self._from_config is not False:

            # check if Panorama
            dg_exists = self._from_config.find('.//device-group')

            # PAN-OS - no Device Groups found
            if dg_exists is None:
                self.ui.text_out.append('> No Device Groups found; assuming PAN-OS config.')
                self.ui.text_out.append('> <b><font color="green">Select VSYS if necessary.</font></b>')

                # populate from VSYS
                self._vsys = []
                for vsys in self._from_config.xpath('//config/devices/entry/vsys/entry'):
                    self._vsys.append(vsys.get('name'))

                self.ui.combo_from_vsys.addItems(self._vsys)
                self.ui.combo_from_rulebase.clear()

            # Panorama - populate from DG
            else:
                self.ui.text_out.append('> Device Groups detected!')
                self.ui.text_out.append('> <b><font color="green">Please select To/From DG...</font></b>')
                self.ui.text_out.append('> <b><font color="green">Please select Pre/Post Rulebase...</font></b>')

                self._from_device_groups = ['Shared']
                for dg in self._from_config.xpath('//config/devices/entry/device-group/entry'):
                    self._from_device_groups.append(dg.get('name'))

                self.ui.combo_from_dg.addItems(self._from_device_groups)
                self.ui.combo_from_rulebase.addItems(['Select Rulebase', 'Pre Rulebase', 'Post Rulebase'])

        self.ui.progress_bar.setValue(100)

    ##############################################
    # SYSTEM INFO
    ##############################################
    def _system_info(self):
        """
        Show System Info: set status bar and get device info
        """

        values = {'type': 'op', 'cmd': '<show><system><info></info></system></show>', 'key': self._api}
        result, respose, error = self._api_request(values)

        # get device info
        if result:
            root = lxml.fromstring(respose)
            model = root.findtext('.//model')
            self._device = root.findtext('.//devicename')
            self._sw = root.findtext('.//sw-version')

            # set status bar
            self.ui.statusbar.showMessage('{m:12} {x:5}|{x:5} {d:15} {x:5}|{x:5} {s:8}'.format(m=model, d=self._device, s=self._sw, x=''))
            self.ui.progress_bar.setValue(50)

        if model == 'Panorama' or model == 'M-500' or model == 'M-100':
            self._model = 'Panorama'
        else:
            self._model = 'FW'

    ##############################################
    # FILL TO COMBO BOXES
    ##############################################
    def _fill_to_combo_boxes(self, values):
        """
        Sets the "TO" combo boxes: DG and/or VSYS and Pre/Post Rulebase
        """

        # if succssful
        if values['result'] is True and lxml.fromstring(values['response']).get('status') == 'success':
            self._running_config = lxml.fromstring(values['response'])
            self.ui.text_out.append('> "{name}" has been loaded!'.format(name='running-config.xml'))

        else:
            self.ui.text_out.clear()
            self.ui.text_out.append('> Error loading "{name}". Please try again.'.format(name='running-config.xml'))
            self.ui.text_out.append('> {error}'.format(error=values['error']))
            self._from_config = False

        # Panorama - set To DG
        if self._model == 'Panorama':
            self._to_device_groups = ['Shared']
            for dg in self._running_config.xpath('//config/devices/entry/device-group/entry'):
                self._to_device_groups.append(dg.get('name'))

            self.ui.combo_to_dg.addItems(self._to_device_groups)
            self.ui.combo_to_rulebase.addItems(['Select Rulebase', 'Pre Rulebase', 'Post Rulebase'])

        # PAN-OS - set To VSYS
        else:
            self._to_vsys = []
            for vsys in self._running_config.xpath('//config/devices/entry/vsys/entry'):
                self._to_vsys.append(vsys.get('name'))

            self.ui.combo_to_vsys.addItems(self._to_vsys)
            self.ui.combo_to_rulebase.clear()

        self.ui.progress_bar.setValue(75)

    ##############################################
    # LOAD SAVED CONFIG
    ##############################################
    def _load_saved_configs(self, output):
        """
        Establish SSH connection to FW and get a list of Saved Configs
        Update "From" file combo box
        """

        lines = output.splitlines()
        self._files = []

        # update text out
        self.ui.text_out.append('> Saved Config Files have been loaded!')
        self.ui.text_out.append('> <b><font color="green">Please select a file...</font></b>')

        for l in lines:
            if re.search(r'(.+)(\dK$)', l):
                self._files.append(l.split()[0])

        # update file combo box (FROM file)
        self._files.insert(0, 'Select a File')
        self.ui.combo_file.clear()
        self.ui.combo_file.addItems(self._files)

        self.ui.progress_bar.setValue(100)

    ##############################################
    # API REQUEST
    ##############################################
    def _api_request(self, values):
        """
        API request driver
        """

        try:
            return True, requests.post(self._url, values, verify=False, timeout=10).text, None
        except requests.exceptions.ConnectionError as error_api:
            return False, 'Error connecting to {ip} - Check IP Address'.format(ip=self._ip), error_api
        except requests.exceptions.Timeout as error_timeout:
            return None, 'Connection to {ip} timed out, please try again'.format(ip=self._ip), error_timeout

    ##############################################
    # SHOW ERROR
    ##############################################
    def _show_critical_error(self, message_list):

        message = '''
        <p>
        {message}
        <br>
        Error: {error}
        </p>
        '''.format(message=message_list[0], error=message_list[1])

        result = QMessageBox.critical(self, 'ERROR', message, QMessageBox.Abort, QMessageBox.Retry)

        # Abort
        if result == QMessageBox.Abort:
            self.close()

        # Retry
        else:

            # set error flag to True -- implies error
            self._flag_error = True
            return


############################################################################
# MAIN
############################################################################
if __name__ == '__main__':
    app = QApplication(sys.argv)
    app.setStyle('Fusion')
    palette = QPalette()
    palette.setColor(QPalette.Window, QColor(53, 53, 53))
    palette.setColor(QPalette.WindowText, QtCore.Qt.white)
    palette.setColor(QPalette.Base, QColor(15, 15, 15))
    palette.setColor(QPalette.AlternateBase, QColor(53, 53, 53))
    palette.setColor(QPalette.ToolTipBase, QtCore.Qt.white)
    palette.setColor(QPalette.ToolTipText, QtCore.Qt.white)
    palette.setColor(QPalette.Text, QtCore.Qt.white)
    palette.setColor(QPalette.Button, QColor(53, 53, 53))
    palette.setColor(QPalette.ButtonText, QtCore.Qt.white)
    palette.setColor(QPalette.BrightText, QtCore.Qt.red)

    palette.setColor(QPalette.Highlight, QColor(25, 193, 255).lighter())
    palette.setColor(QPalette.HighlightedText, QtCore.Qt.black)
    app.setPalette(palette)
    main = LoadPartialMainWindow()
    main.show()
    sys.exit(app.exec_())