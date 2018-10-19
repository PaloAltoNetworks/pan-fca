from ansible import errors

def item_to_list(string):
    #try:
    if True:
        if isinstance(string, basestring):
            return [string]
        else:
            return string
    #except Exception, e:
    #    raise errors.AnsibleFilterError('There was a issue converting string %s to a list of one"' % str(string) )

class FilterModule(object):
    ''' A filter to split a string into a list. '''
    def filters(self):
        return {
            'item_to_list' : item_to_list,
        }
