#!/usr/bin/env python
# -*- coding: utf-8 -*-

from pandevice import firewall, network as n, objects, panorama

baseBgp = ('<bgp><routing-options><graceful-restart><enable>yes</enable>' \
           '</graceful-restart></routing-options><enable>yes</enable><router-id>%s</router-id>' \
           '<local-as>%s</local-as></bgp>')
bgpXpath = ("/config/devices/entry[@name='localhost.localdomain']/network/virtual-router/entry[@name='%s']/protocol/bgp")

class panconnect(object):
    def __init__(self,host,key,pano=False):
        if pano == True:
            self.conn = panorama.Panorama(hostname=host, api_key=key)
        else:
            self.conn = firewall.Firewall(hostname=host, api_key=key)

class create_vr(object):
    def __init__(self,name,fw=None,pano=None):
        if pano:
            vr = n.VirtualRouter(name=name)
            pano.add(vr)
            vr.create()
        else:
            vr = n.VirtualRouter(name=name)
            fw.add(vr)
            vr.create()

class configure_bgp(object):
    def __init__(self,name,fw=None,pano=None):
        if pano:
            print 'use panorama'
        else:
            print 'use firewall'