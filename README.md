digitalocean-shell-api
======================

Shell scripts acting as client for the [DigitalOcean API][]

## LANGUAGE ##

Shell (dash)

## TARGET PLATFORM ##

Ubuntu 12.04 LTS

## DEPENDENCIES ##

* [curl][] (installed with `setup/install.sh`,
            removed with `setup/uninstall.sh`)
* [JSON.sh][] (installed as a git submodule)

## FIRST STEPS ##

    # Install dependencies and initialize git submodules
    ./setup/install.sh

Login to your account on DigitalOcean.com and copy the Client ID and API Key
that you find there to initialize the corresponding variables in config.sh at
the root of this project:

    # Configuration of Identification for DigitalOcean API

    # Client ID
    CLIENT_ID=

    # API Key
    API_KEY=

## USAGE ##

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
    + *Input Fields:* any
    + *Output Fields:*
      - `id` - identifier of the geographical region
      - `name` - description of the region, e.g. 'New York 1'

### /images ###

  * `images/list.sh` - list all images available in your account
                     public images and private snapshots and backups
    + *Input Fields:* any
    + *Output Fields:*
      - `id` - identifier of the image (or snapshot or backup)
      - `name` - description of the image (or snapshot or backup)
      - `distribution` - name of the OS distribution (e.g. 'Ubuntu')
      - `public` - whether the image is public or private (`true`|`false`)

  * `images/read.sh` - get the properties of given image
    + *Input Fields:*
      - `id` - identifier of the image
      - optionally followed with any fields
    + *Output Fields:*
      - `id` - identifier of the image (or snapshot or backup)
      - `name` - description of the image (or snapshot or backup)
      - `distribution` - name of the OS distribution (e.g. 'Ubuntu')
      - `public` - whether the image is public or private (`true`|`false`)

  * `images/delete.sh` - destroy the given image
    + *Input Fields:*
      - `id` - identifier of the image
      - optionally followed with any fields
    + *Output Fields:*
      - None

  * `images/transfer.sh` - transfer the given image to the selected region  
    (run regions/list.sh to list all available regions)
    + *Input Fields:*
      - `id` - identifier of the image
      - `region_id` - identifier of the geographical region
      - optionally followed with any fields
    + *Output Fields:*
      - `event_id` - event identifier to track progress of the image transfer

### /ssh_keys ###

  * `ssh_keys/list.sh` - list all SSH public keys associated with your account
    + *Input Fields:* any
    + *Output Fields:*
      - `id` - identifier of the SSH public key
      - `name` - your description of the key

  * `ssh_keys/add.sh` - add the given SSH public key to your account
    + *Input Fields:*
      - `id` - identifier of the SSH public key
      - `name` - description of the key
      - `ssh_pub_key` - the full text of the SSH public key
      - optionally followed with any fields
    + *Output Fields:*
      - `id` - identifier of the SSH public key
      - `name` - description of the key
      - `ssh_pub_key` - the full text of the SSH public key

  * `ssh_keys/read.sh` - get the properties of the given SSH public key
    + *Input Fields:*
      - `id` - identifier of the SSH public key
      - optionally followed with any fields
    + *Output Fields:*
      - `id` - identifier of the SSH public key
      - `name` - description of the key
      - `ssh_pub_key` - the full text of the SSH public key

  * `ssh_keys/update.sh` - update the given SSH public key
    + *Input Fields:*
      - `id` - identifier of the SSH public key
      - `name` - description of the key (ignored?)
      - `ssh_pub_key` - the updated full text of the SSH public key
      - optionally followed with any fields
    + *Output Fields:*
      - `id` - identifier of the SSH public key
      - `name` - description of the key
      - `ssh_pub_key` - the full text of the SSH public key

  * `ssh_keys/remove.sh` - remove the given SSH public key from the account
    + *Input Fields:*
      - `id` - identifier of the SSH public key
      - optionally followed with any fields
    + *Output Fields:*
      - None

### /sizes ###

  * `sizes/list.sh` - list all droplet sizes available (commercial offers)
    + *Input Fields:* any
    + *Output Fields:*
      - `id` - identifier of the size (commercial offer)
      - `name` - description of the size, e.g. '512MB'
      - `memory` - RAM in megabytes (e.g. '1024' for 1GB)
      - `cpu` - number of CPU cores
      - `disk` - SSD disk space in gigabytes
      - `cost_per_hour` - cost per hour in dollars (floating point number)
      - `cost_per_month` - cost per month in dollars (floating point number)

### /domains ###

  * `domains/list.sh` - list all domains registered in the account
    + *Input Fields:* any
    + *Output Fields:*
      - `id` - identifier of the domain
      - `name` - domain name, in hostname format

  * `domains/add.sh` - add a DNS A record for given domain
    + *Input Fields:*
      - `name` - domain name, in hostname format
      - `ip_address` - IPv4 address for the new A record
      - optionally followed with any fields
    + *Output Fields:*
      - `id` - identifier of the domain name
      - `name` - domain name, in hostname format

  * `domains/read.sh` - get the properties of the given domain
    + *Input Fields:*
      - `id` - identifier of the domain name
      - optionally followed with any fields
    + *Output Fields:*
      - `id` - identifier of the domain
      - `name` - domain name, in hostname format
      - `ttl` - time to live, undocumented
      - `live_zone_file` - escaped text of the zone file, undocumented
      - `error` - undocumented
      - `zone_file_with_error` - undocumented

  * `domains/remove.sh` - remove the given domain from the account
    + *Input Fields:*
      - `id` - identifier of the domain name
      - optionally followed with any fields
    + *Output Fields:*
      - None

  * `domains/records/list.sh` - list all DNS records for the given domain
    + *Input Fields:*
      - `id` - identifier of the domain name
      - optionally followed with any fields
    + *Output Fields:*
      - `id` - identifier of the domain
      - `record_id` - identifier of the DNS record
      - `record_type` - DNS record type (`A`|`CNAME`|`NS`|`TXT`|`MX`|`SRV`)
      - `data` - value of the DNS record
      - `name` - name of the subdomain, in hostname format (may be empty)
      - `priority` - priority (integer or empty)
      - `port` - port (integer or empty)
      - `weight` - weight (integer or empty)

  * `domains/records/add.sh` - add a DNS record for given domain
    + *Input Fields:*
      - `id` - identifier of the domain name
      - `record_type` - DNS record type (`A`|`CNAME`|`NS`|`TXT`|`MX`|`SRV`)
      - `data` - value of the DNS record
      - optionally followed with `name` - name of the subdomain, in hostname
        format, required for record types `A`, `CNAME`, `TXT` and `SRV`,
        may be left empty for other types of records
      - optionally followed with `priority` - priority (integer), required for
        `MX` and `SRV` records, may be left empty for other types of records
      - optionally followed with `port` - port (integer), required for `SRV`
        records, may be left empty for other types of records
      - optionally followed with `weight` - weight (integer), required for
        `SRV` records, may be left empty for other types of records
      - optionally followed with any fields
    + *Output Fields:*
      - `id` - identifier of the domain
      - `record_id` - identifier of the DNS record
      - `record_type` - DNS record type (`A`|`CNAME`|`NS`|`TXT`|`MX`|`SRV`)
      - `data` - value of the DNS record
      - `name` - name of the subdomain, in hostname format (may be empty)
      - `priority` - priority (integer or empty)
      - `port` - port (integer or empty)
      - `weight` - weight (integer or empty)

  * `domains/records/read.sh` - get the properties of the given domain/record
    + *Input Fields:*
      - `id` - identifier of the domain name
      - `record_type` - DNS record type (`A`|`CNAME`|`NS`|`TXT`|`MX`|`SRV`)
      - optionally followed with any fields
    + *Output Fields:*
      - `id` - identifier of the domain
      - `record_id` - identifier of the DNS record
      - `record_type` - DNS record type (`A`|`CNAME`|`NS`|`TXT`|`MX`|`SRV`)
      - `data` - value of the DNS record
      - `name` - name of the subdomain, in hostname format (may be empty)
      - `priority` - priority (integer or empty)
      - `port` - port (integer or empty)
      - `weight` - weight (integer or empty)

  * `domains/records/update.sh` - update the given domain/record
    + *Input Fields:*
      - `id` - identifier of the domain name
      - `record_id` - identifier of the DNS record
      - `record_type` - DNS record type (`A`|`CNAME`|`NS`|`TXT`|`MX`|`SRV`)
      - `data` - value of the DNS record
      - optionally followed with `name` - name of the subdomain, in hostname
        format, required for record types `A`, `CNAME`, `TXT` and `SRV`,
        may be left empty for other types of records
      - optionally followed with `priority` - priority (integer), required for
        `MX` and `SRV` records, may be left empty for other types of records
      - optionally followed with `port` - port (integer), required for `SRV`
        records, may be left empty for other types of records
      - optionally followed with `weight` - weight (integer), required for
        `SRV` records, may be left empty for other types of records
      - optionally followed with any fields
    + *Output Fields:*
      - `id` - identifier of the domain
      - `record_id` - identifier of the DNS record
      - `record_type` - DNS record type (`A`|`CNAME`|`NS`|`TXT`|`MX`|`SRV`)
      - `data` - value of the DNS record
      - `name` - name of the subdomain, in hostname format (may be empty)
      - `priority` - priority (integer or empty)
      - `port` - port (integer or empty)
      - `weight` - weight (integer or empty)

  * `domains/records/remove.sh` - remove the given DNS record of given domain
    + *Input Fields:*
      - `id` - identifier of the domain name
      - `record_id` - identifier of the DNS record
      - optionally followed with any fields
    + *Output Fields:*
      - None

### /events ###

  * `events/read.sh` - get the properties of the given event
    + *Input Fields:*
      - `id` - event identifier
      - optionally followed with any fields
    + *Output Fields:*
      - `id` - event identifier
      - 'percentage' - operation progress in percents
      - 'action_status' - status of the operation (`done`|...)
      - 'droplet_id' - identifier of the affected droplet
      - 'event_type_id' - identifier of the event type, undocumented

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

[curl]: http://curl.haxx.se/

3. [JSON.sh - a pipeable JSON parser written in Bash][JSON.sh]

[JSON.sh]: https://github.com/dominictarr/JSON.sh

4. [seashell - a Bash client for the DigitalOcean API][seashell]

[seashell]: https://github.com/jogfsovt/seashell

## AUTHOR ##

Eric Bréchemier <github@eric.brechemier.name>

## LICENSE ##

MIT
