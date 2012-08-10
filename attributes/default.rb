
include_attribute 'upstart::default'

default.cred_thingy.dist_tag = '0.1.0'
default.cred_thingy.dist_dir = Pathname.new '/opt/cred_thingy'
default.cred_thingy.deps_dir = Promise.new { cred_thingy.dist_dir + 'deps' }
default.cred_thingy.conf_dir = Pathname.new '/etc/cred_thingy'
default.cred_thingy.config = Promise.new { cred_thingy.conf_dir + 'cred_thingy.conf' }

default.cred_thingy.git_repo = 'git://github.com/dlobue/cred_thingy.git'

default.cred_thingy.upstart_conf = Promise.new { upstart.conf_dir + 'cred_thingy.conf' }


default.cred_thingy.bucket_name = 'bmuse1-deployments'
default.cred_thingy.path_prefix = "instance_creds"
default.cred_thingy.queue_name = "asg_notifications"
default.cred_thingy.loglevel = 'DEBUG'

