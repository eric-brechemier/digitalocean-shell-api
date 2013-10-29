digitalocean-shell-api
======================

Shell scripts acting as client for the [DigitalOcean API][]

## LANGUAGE ##

Shell (dash)

## TARGET PLATFORM ##

Ubuntu 12.04 LTS

## USAGE ##

The Client ID and API Key shall be set in config.sh found at the root
of this project.

The scripts are organized in folders that map the [HTTP API of DigitalOcean]
[DigitalOcean API], with a separate script for each API method.
Parameters are provided as `key=value` pairs.

Each HTTP method returns an object with two properties, 'status' (`OK` or
`ERROR`) and either property named after the type of the expected result
('droplets', 'droplet', 'regions', 'images', 'image', 'ssh\_keys', 'ssh\_key',
'sizes, 'domains', 'domain', 'records', 'record', 'domain\_record', 'event')
depending on the section of the API or an 'event\_id' property to track the
progress of a long operation.

Each script in this client reads a list of lines in a tab-separated format
from the standard input and writes text in the same format to the standard
output. Lines starting with a '#' are treated as comments and ignored in the
input. The first line of output is a comment which lists headers for the
tabular data.

The exit status of each script is set according to the 'status' in the response
of the HTTP API: `0` for `OK` and `1` for `ERROR`). This allows to chain
commands depending on the result of an operation. The associated error message
is printed to the standard error output.

### /droplets ###

  * `droplets/list.sh` - list all active droplets
    + *Input Fields:* any
    + *Output Fields*
      - `id` - droplet identifier
      - `name` - name of the droplet, in hostname format
      - `status` - status of the droplet (`active`|...)
      - `locked` - whether the droplet is locked (`true`|`false`)
      - `backups_active` - whether daily backups are enabled (`true`|`false`)
      - `created_at` - creation date/time in ISO format (UTC)
      - `size_id` - identifier of the droplet size (commercial offer)
      - `image_id` - identifier of the image
      - `region_id` - identifier of geographical region
      - `ip_address` - IP address of the droplet
      - `private_ip_address` - private IP address of the droplet

  * `droplets/create.sh` - create a new droplet with given properties
    + *Input Fields:*
      - `name` - name of the droplet, in hostname format
      - `size_id` - identifier of the droplet size (commercial offer)
      - `image_id` - identifier of the image
      - `region_id` - identifier of geographical region
      - optionally followed with `ssh_key_ids` - comma-separated list of
        identifiers of SSH public keys
      - optionally followed with `private_networking` - whether to enable
        private networking, if supported in the region (`true`|`false`)
      - optionally followed with any fields
    + *Output Fields:*
      - `event_id` - event identifier to track progress of droplet creation

  * `droplets/read.sh` - get the properties of the given droplet
    + *Input Fields:*
      - `id` - identifier of the droplet
      - optionally followed with any fields
    + *Output Fields:*
      - `id` - droplet identifier
      - `name` - name of the droplet, in hostname format
      - `status` - status of the droplet (`active`|...)
      - `locked` - whether the droplet is locked (`true`|`false`)
      - `backups_active` - whether daily backups are enabled (`true`|`false`)
      - `created_at` - creation date/time in ISO format (UTC)
      - `size_id` - identifier of the droplet size (commercial offer)
      - `image_id` - identifier of the image
      - `region_id` - identifier of geographical region
      - `ip_address` - IP address of the droplet
      - `private_ip_address` - private IP address of the droplet

  * `droplets/reboot.sh` - reboot the given droplet
    + *Input Fields:*
      - `id` - identifier of the droplet
      - optionally followed with any fields
    + *Output Fields:*
      - `event_id` - event identifier to track progress of reboot

  * `droplets/power_cycle.sh` - turn off and on the given droplet
    + *Input Fields:*
      - `id` - identifier of the droplet
      - optionally followed with any fields
    + *Output Fields:*
      - `event_id` - event identifier to track progress of power cycle

  * `droplets/shutdown.sh` - shutdown the droplet with given identifier
    + *Input Fields:*
      - `id` - identifier of the droplet
      - optionally followed with any fields
    + *Output Fields:*
      - `event_id` - event identifier to track progress of shutdown

  * `droplets/power_off.sh` - turn off the given droplet
    + *Input Fields:*
      - `id` - identifier of the droplet
      - optionally followed with any fields
    + *Output Fields:*
      - `event_id` - event identifier to track progress of power off operation

  * `droplets/power_on.sh` - turn on the given droplet
    + *Input Fields:*
      - `id` - identifier of the droplet
      - optionally followed with any fields
    + *Output Fields:*
      - `event_id` - event identifier to track progress of power on operation

  * `droplets/password_reset.sh` - reset the root password of given droplet
    + *Input Fields:*
      - `id` - identifier of the droplet
      - optionally followed with any fields
    + *Output Fields:*
      - `event_id` - identifier of event for password reset operation

  * `droplets/resize.sh` - change the given droplet to selected size  
    (run `sizes/list.sh` to get the list of available sizes)
    + *Input Fields:*
      - `id` - identifier of the droplet
      - `size_id` - identifier of the new size (commercial offer)
      - optionally followed with any fields
    + *Output Fields:*
      - `event_id` - identifier of event for resizing operation

  * `droplets/snapshots/list.sh` - get the list of snapshots of given droplet
    + *Input Fields:*
      - `id` - identifier of the droplet
      - optionally followed with any fields
    + *Output Fields:*
      - `id` - identifier of the snapshot image
      - `name` - name of the snapshot image, given at creation or set based
                 on creation date/time if omitted

  * `droplets/snapshot.sh` - take a snapshot of the given droplet and save it
    with the given name, or if omitted, a name based on current date/time
    + *Input Fields:*
      - `id` - identifier of the droplet
      - optionally followed with `name` - name of the snapshot
      - optionally followed with any fields
    + *Output Fields:*
      - `event_id` - event identifier to track progress of snapshot creation

  * `droplets/restore.sh` - restore the given droplet using selected image  
    (run images/list.sh to get the list of available images)
    + *Input Fields:*
      - `id` - identifier of the droplet
      - `image_id` - identifier of the image (or snapshot or backup)
      - optionally followed with any fields
    + *Output Fields:*
      - `event_id` - event identifier to track progress of droplet restoration

  * `droplets/rebuild.sh` - reset the given droplet to the initial image  
    (restart from scratch with the same IP)
    + *Input Fields:*
      - `id` - identifier of the droplet
      - optionally followed with any fields
    + *Output Fields:*
      - `event_id` - event identifier to track progress of rebuild operation

  * droplets/backups/list.sh - get the list of backups for given droplet
    + *Input Fields:*
      - `id` - identifier of the droplet
      - optionally followed with any fields
    + *Output Fields:*
      - `id` - identifier of the backup image
      - `name` - description of the backup image, e.g. 'Automated Backup'

  * `droplets/enable_backups.sh` - enable daily backups of given droplet
    + *Input Fields:*
      - `id` - identifier of the droplet
      - optionally followed with any fields
    + *Output Fields:*
      - `event_id` - event identifier to track progress of backup activation

  * `droplets/disable_backups.sh` - disable daily backups of the given droplet
    + *Input Fields:*
      - `id` - identifier of the droplet
      - optionally followed with any fields
    + *Output Fields:*
      - `event_id` - event identifier to track progress of backup deactivation

  * `droplets/rename.sh` - rename the given droplet
    + *Input Fields:*
      - `id` - identifier of the droplet
      - `name` - new name of the droplet, in hostname format
      - optionally followed with any fields
    + *Output Fields:*
      - `event_id` - event identifier to track progress of droplet renaming

  * `droplets/delete.sh` - destroy the given droplet (this is irreversible)
    + *Input Fields:*
      - `id` - identifier of the droplet
      - optionally followed with any fields
    + *Output Fields:*
      - `event_id` - event identifier to track progress of droplet destruction

### /regions ###

  * `regions/list.sh` - list all geographical regions available
    + *Input Fields:*
    + *Output Fields:*

### /images ###

  * `images/list.sh` - list all images available with your client id:
                     public images and private snapshots and backups
    + *Input Fields:*
    + *Output Fields:*

  * `images/create.sh name='snapshot1' droplet=42` - create a snapshot of the
                                                   droplet with id=42 and give
                                                   it the name 'snapshot1'.
                                                   When the name is omitted,
                                                   a name based on current
                                                   date/time will be assigned.
                                                 (this script defines an alias
                                                    for droplets/snapshot.sh)
    + *Input Fields:*
    + *Output Fields:*

  * `images/read.sh id=1` - get the properties of image with id=1
    + *Input Fields:*
    + *Output Fields:*

  * `images/delete.sh id=1` - destroy the image
    + *Input Fields:*
    + *Output Fields:*

  * `images/transfer.sh id=1 region=3` - transfer the image to the region with id=3
                            (run regions/list.sh to list all available regions)
    + *Input Fields:*
    + *Output Fields:*

### /ssh_keys ###

  * `ssh_keys/list.sh` - list all SSH public keys associated with your account
    + *Input Fields:*
    + *Output Fields:*

  * `ssh_keys/add.sh name='example.org' key='...'` - add the given SSH public key
                                                    with the name 'example.org'
    + *Input Fields:*
    + *Output Fields:*

  * `ssh_keys/read.sh id=42` - get the properties of the SSH public key with id=42
    + *Input Fields:*
    + *Output Fields:*

  * `ssh_keys/update.sh id=42 key='...'` - update the SSH public key
    + *Input Fields:*
    + *Output Fields:*

  * `ssh_keys/remove.sh id=42` - remove the SSH public key from the account
    + *Input Fields:*
    + *Output Fields:*

### /sizes ###

  * `sizes/list.sh` - list all droplet sizes available (commercial offers)
    + *Input Fields:*
    + *Output Fields:*

### /domains ###

  * `domains/list.sh` - list all domain names registered in the account
    + *Input Fields:*
    + *Output Fields:*

  * `domains/add.sh name='example.org' ip='1.2.3.4'` - add domain 'example.org'
                                                   and create an A record for
                                                   the IP address '1.2.3.4'
    + *Input Fields:*
    + *Output Fields:*

  * `domains/read.sh id=42` - get the properties of the domain with id=42
    + *Input Fields:*
    + *Output Fields:*

  * `domains/remove.sh id=42` - remove the domain from the account 
    + *Input Fields:*
    + *Output Fields:*

  * `domains/records/list.sh domain=42` - list all DNS records for the domain id=42
    + *Input Fields:*
    + *Output Fields:*

  * `domains/records/add.sh domain=42 type='A' data='1.2.3.4'` -
                            add a custom DNS record for the domain.
                            Supported types are 'A', 'CNAME', 'NS', 'TXT',
                            'MX' and 'SRV'. The value of the record is provided
                            in property 'data'. Three additional parameters
                            can be provided: 'priority' (required for 'SRV'
                            and 'MX' records), 'port' (required for 'SRV'
                            records) and 'weight' (required for 'SRV' records).
    + *Input Fields:*
    + *Output Fields:*

  * `domains/records/read.sh domain=42 record=1` - get the properties of the record
                                               with id=1 for the domain id=42
    + *Input Fields:*
    + *Output Fields:*

  * `domains/records/update.sh domain=42 record=1 type='A' data='1.2.3.4'` -
                                update the properties of the DNS record id=1
                                for the domain id=42. The same parameters as
                                `domains/records/add.sh` are supported here.
    + *Input Fields:*
    + *Output Fields:*

  * `domains/records/remove.sh domain=42 record=1` - remove the record with id=1
                                                     for the domain id=42
    + *Input Fields:*
    + *Output Fields:*

### /events ###

  * `events/read.sh id=42` - get the properties of the event with id=42.
                         This method is useful to track the progression
                         of an event, returned in percents in event.percentage
                         in response data.
    + *Input Fields:*
    + *Output Fields:*

## ROADMAP ##

TODO: write unit tests to check that each script produces the expected URL,
by replacing the common function used in all scripts to query the HTTP API,
checking the value without producing any actual request instead.

## REFERENCES ##

1. [SSD Cloud Server, VPS Server, Simple Cloud Hosting by DigitalOcean]
   [DigitalOcean]

[DigitalOcean]: https://www.digitalocean.com

2. [DigitalOcean API][]

[DigitalOcean API]: https://www.digitalocean.com/api/

3. [JSON.sh - a pipeable JSON parser written in Bash][JSON.sh]

[JSON.sh]: https://github.com/dominictarr/JSON.sh

4. [seashell - a Bash client for the DigitalOcean API][seashell]

[seashell]: https://github.com/jogfsovt/seashell

## AUTHOR ##

Eric Bréchemier <github@eric.brechemier.name>

## LICENSE ##

MIT
