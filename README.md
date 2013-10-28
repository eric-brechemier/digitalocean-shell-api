digitalocean-shell-api
======================

Shell scripts acting as client for the DigitalOcean API

## LANGUAGE ##

Shell (dash)

## TARGET PLATFORM ##

Ubuntu 12.04 LTS

## USAGE ##

The Client ID and API Key shall be set in config.sh found at the root
of this project.

The scripts are organized in folders that map the HTTP API of DigitalOcean,
with a separate script for each API method. Parameters are provided as
`key=value` pairs.

Each HTTP method returns an object with two properties, 'status' (`OK` or
`ERROR`) and either property named after the type of the expected result
('droplets', 'droplet', 'regions', 'images', 'image', 'ssh\_keys', 'ssh\_key',
'sizes, 'domains', 'domain', 'records', 'record', 'domain\_record', 'event')
depending on the section of the API or an 'event\_id' property to track the
progress of a long operation.

The scripts in this shell client set the status code based on the 'status'
(0 for `OK` and 1 for `ERROR`), which allows to chain commands depending on
the result of a call, and print only the payload extracted from the result,
i.e. the value of the other property found in the response, once parsed and
reformatted by JSON.sh to allow piping to grep and other text processing tools.

### /droplets ###

* droplets/list.sh - list all active droplets
* droplets/create.sh - create a new droplet
* droplets/read.sh id=42 - get the properties of the droplet with id=42
* droplets/reboot.sh id=42 - reboot the droplet
* droplets/power\_cycle.sh id=42 - turn off and on the droplet
* droplets/shutdown.sh id=42 - shutdown the droplet
* droplets/power\_off.sh id=42 - turn off the droplet
* droplets/power\_on.sh id=42 - turn on the droplet
* droplets/password\_reset.sh id=42 - reset root password of the droplet
* droplets/resize.sh id=42 size=99 - change the droplet to the size with id 99
                        (run sizes/list.sh to get the list of available sizes)
* droplets/snapshot.sh id=42 name='snapshot1' - take a snapshot of the droplet
                                        and save it with the name 'snapshot1'.
                                        When the name is omitted, a name based
                                        on current date/time will be assigned.
* droplets/restore.sh id=42 image=123 - Restore the droplet using the image
                                        (or snapshot or backup) with id 123.
                     (run images/list.sh to get the list of available images)
* droplets/rebuild.sh id=42 - Restore the droplet to the default image
                              (restart from scratch with the same IP)
* droplets/enable\_backups.sh id=42 - enable daily backups of the droplet
* droplets/disable\_backups.sh id=42 - disable daily backups of the droplet
* droplets/rename.sh id=42 name='droplet1' - rename the given droplet
                                             to 'droplet1'
* droplets/delete.sh id=42 - destroy the droplet (this is irreversible)

### /regions ###

* regions/list.sh - list all geographical regions available

### /images ###

* images/list.sh - list all images available with your client id:
                   public images and private snapshots and backups
* images/create.sh name='snapshot1' droplet=42 - create a snapshot of the
                                                 droplet with id=42 and give
                                                 it the name 'snapshot1'.
                                                 When the name is omitted,
                                                 a name based on current
                                                 date/time will be assigned.
                                                 (this script defines an alias
                                                  for droplets/snapshot.sh)
* images/read.sh id=1 - get the properties of image with id=1
* images/delete.sh id=1 - destroy the image
* images/transfer.sh id=1 region=3 - transfer the image to the region with id=3
                            (run regions/list.sh to list all available regions)

### /ssh\_keys ###

* ssh\_keys/list.sh - list all SSH public keys associated with your account
* ssh\_keys/add.sh name='example.org' key='...' - add the given SSH public key
                                                  with the name 'example.org'
* ssh\_keys/read.sh id=42 - get the properties of the SSH public key with id=42
* ssh\_keys/update.sh id=42 key='...' - update the SSH public key
* ssh\_keys/remove.sh id=42 - remove the SSH public key from the account

### /sizes ###

* sizes/list.sh - list all droplet sizes available (commercial offers)

### /domains ###

* domains/list.sh - list all domain names registered in the account
* domains/add.sh name='example.org' ip='1.2.3.4' - add domain 'example.org'
                                                   and create an A record for
                                                   the IP address '1.2.3.4'
* domains/read.sh id=42 - get the properties of the domain with id=42
* domains/remove.sh id=42 - remove the domain from the account 
* domains/records/list.sh domain=42 - list all DNS records for the domain id=42
* domains/records/add.sh domain=42 type='A' data='1.2.3.4' -
                            add a custom DNS record for the domain.
                            Supported types are 'A', 'CNAME', 'NS', 'TXT',
                            'MX' and 'SRV'. The value of the record is provided
                            in property 'data'. Three additional parameters
                            can be provided: 'priority' (required for 'SRV'
                            and 'MX' records), 'port' (required for 'SRV'
                            records) and 'weight' (required for 'SRV' records).
* domains/records/read.sh domain=42 record=1 - get the properties of the record
                                               with id=1 for the domain id=42
* domains/records/update.sh domain=42 record=1 type='A' data='1.2.3.4' -
                            update the properties of the DNS record id=1
                            for the domain id=42. The same parameters as
                            `domains/records/add.sh` are supported here.
* domains/records/remove.sh domain=42 record=1 - remove the record with id=1
                                                 for the domain id=42

### /events ###

* events/read.sh id=42 - get the properties of the event with id=42.
                         This method is useful to track the progression
                         of an event, returned in percents in event.percentage
                         in response data.

## ROADMAP ##

TODO: simplify the output of each method, returning only a list of identifiers
in list.sh scripts? Full details can then be retrieved with read.sh.

TODO: write unit tests to check that each script produces the expected URL,
by replacing the common function used in all scripts to query the HTTP API,
checking the value without producing any actual request instead.

## REFERENCES ##

* [1] SSD Cloud Server, VPS Server, Simple Cloud Hosting by DigitalOcean  
  https://www.digitalocean.com

* [2] DigitalOcean API  
  https://www.digitalocean.com/api/

* [3] JSON.sh - a pipeable JSON parser written in Bash  
  https://github.com/dominictarr/JSON.sh

* [4] seashell - a Bash client for the DigitalOcean API  
  https://github.com/jogfsovt/seashell

## AUTHOR ##

Eric Bréchemier <github@eric.brechemier.name>

## LICENSE ##

MIT
