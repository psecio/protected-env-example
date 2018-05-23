Docker Example for Protected ENV values
=========

This repository is an example of a setup using Apache's `envvars`, and external file and `open_basedir` to prevent direct file access to the confidential settings.

## Usage

Clone the repo and run:

```
docker-compose build; 
docker-compose up;
```

Then go to [http://localhost:80](http://localhost:80) to see the output.

## How it works

When the build is performed, the following happens:

1. All of the files are copied up to the machine (for `/var/www/html`)
2. The Apache configuration is updated to include a version of `000-default.conf` with the `ENC_KEY` value set via `SetEnv` and using the environemnt variable `${ENC_KEY}`
3. The `open_basedir.ini` file is copied over to the right place. This is a PHP ini configuration that enables the `open_basedir` setting and restricts the PHP process from accessing files outside of `/var/www/html`.
4. The `test-settings` file with the `ENC_KEY` value is moved to the right place
5. The contents of the local `envvars` is appended to the main `/etc/apache2/envvars`: `. /tmp/addl-settings`

The `vhost_alias` module is then enabled and the Apache server is restarted. Once it's restarted and you can visit the page and see that, while the script can't access either `/tmp/addl-settings` or `/etc/apache2/envvars` directly, the `ENC_KEY` value is available in the `$_ENV` array.

## What does this solve?

In some recent discussions, it was noted that, even if you put the key for your application encryption outside of the `DocumentRoot` of your app it would still be readable by the PHP process. If a Local File Include attack vector was found, this would allow an attacker to read this key and the code used to decrypt the data in your application.

This setup prevents this as the key value, despite existing on disk, cannot be read directly from PHP. Instead it is referenced via the `$_ENV` variable.

Take this with a grain of salt, however. If the attacker is able to upload a file that can be executed as PHP, they have full access to the values in `$_ENC` including any sensitive values loaded using this method.

Another issue is server breach and the fact that the file with the key is sitting on disk. However, if the attacker has breached the server, you have more to worry about than just a single encryption key being exposed...