A simple tool to help manage schema version

First, create the versions table:

```
create database metadata;
use metadata;
CREATE TABLE `versions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `version_number` int(10) unsigned NOT NULL,
  `alterstatement` text NOT NULL,
  `ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
```
