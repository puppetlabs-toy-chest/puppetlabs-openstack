#!/usr/bin/python

# A simple python tool to help automate the pulling of a changeset
# into a working modules repository.
#
# Will generate the shell commands to grab the changeset, to be
# run in one of the examples directory.
#
# i.e. in examples/allinone
# ./05_up
# ./10_setup_master.sh
# ./11_setup_havana.sh
# python ../../tools/review_checkout.py -c 82324 -u hogepodge | sh -x
# ./20_setup_node.sh
# ./30_deploy.sh

import sys, getopt, json, subprocess, StringIO

def main(argv):
  help_string = 'review_checkout.py -c <changeid> -u <username>'
  changeid = ''
  username = ''
  try:
    opts, args = getopt.getopt(argv, "hc:u:", ["help", "changeid=", "username="])
  except:
    print help_string
    sys.exit(2)
  for opt, arg in opts:
    if opt in ('-h', '--help'):
      print help_string
      sys.exit()
    elif opt in ('-c', '--changeid'):
      changeid = arg
    elif opt in ('-u', '--username'):
      username = arg
  if changeid == '' or username == '':
    print help_string
    sys.exit(2)
  output = StringIO.StringIO(subprocess.check_output(
      ["ssh", "review.openstack.org", "-p", "29418", "-l", username, "gerrit", "query", "--format=JSON", "--current-patch-set", "change:%s" % (changeid)]))
  json_output = json.loads(output.readline())
  patchnumber = json_output['currentPatchSet']
  project = json_output['project']
  ref = patchnumber['ref']
  shortname = project.split('-')[1]
  repository = "ssh://%s@review.openstack.org:29418/%s.git" % (username,project)
  print "cd modules"
  print "git clone %s %s" % (repository, shortname)
  print "cd %s" % (shortname)
  print "git fetch %s %s && git checkout FETCH_HEAD" % (repository, ref)
  print "cd ../.."
  print ""



if __name__ == "__main__":
  main(sys.argv[1:])
