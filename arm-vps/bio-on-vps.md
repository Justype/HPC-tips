# Bioinformatics on VPS

[Oracle provides a free 4 OCPU and 24GB RAM VPS.](https://www.oracle.com/cloud/free/) Although It is an arm server, Python and R run perfectly.

There are two ways to do it:

1. Use SSH to code (VSCode, PyCharm)
2. Expose the server to a custom domain.

My own computer is Windows. And I prefer to use VSCode for Python and RStudio Server for R, so I did them both.

## Install SSH on Windows (no need on Linux and Unix)

[Microsoft Learn](https://learn.microsoft.com/windows/terminal/tutorials/ssh)

Go to `Windows Settings > Apps > Optional features`, then search for "OpenSSH" in your installed features.

![](https://learn.microsoft.com/en-us/windows/terminal/images/ssh-optonialfeatures.png)

## Create and Connect to Instance

1. Choose image and shape (I used Ubuntu)
2. Download private key
3. Create it

connect to the instance with private key

1. launch `Terminal`
2. `ssh -i <path of your private SSH key> user@instance_ip`
    - for example `ssh -i ~\.ssh\ssh-key-arm.key ubuntu@1.1.1.1`
3. It should prompt a server key, type `yes` to remember it.
4. You will see `user@name_of_instance`

## SFTP

[FileZilla](https://filezilla-project.org/)

Mount your site as a drive (on Windows)

[Installation](https://github.com/winfsp/sshfs-win)

1. [winfsp](https://github.com/billziss-gh/winfsp/releases/latest)
2. [sshfs-win](https://github.com/billziss-gh/sshfs-win/releases)
3. [sshfs-win-manager](https://github.com/evsar3/sshfs-win-manager/releases/latest)

## VSCode SSH

1. install Remote-SSH on VSCode Extension
2. click `Remote Explorer`
3. click `config`
4. select `.ssh\config`
5. change the file

```
Host <name you want>
  HostName <ip address or the domain of instance>
  IdentityFile <path of your private SSH key>
  User <user name>
```

for example

```
Host arm
  HostName 1.1.1.1
  IdentityFile ~/.ssh/ssh-key-arm.key
  User ubuntu
```

And the connection should be successful.

Then enjoy coding on VSCode.

## Custom Domain

You will need an own domain here. or You can register a free subdomain on those website like [ChangeIP.com](https://www.changeip.com/dns.php) (CLAIM FREE DYNAMIC DNS, you can claim multiple domains here).

### Change Firewall Settings

open Port 80,443 on both your instance provider and the linux machine.

#### Firewall of Provider

(My Instance setting. Yours may be different.)

1. Go to instance, and click `Subnet` from `Primary VNIC`
2. change default `Security List`
3. add 0.0.0.0/0 TCP with Destination Port 80,443

#### Firewall of Ubuntu

The Firewall of ubuntu is `iptables`

```bash
sudo nano /etc/iptables/rules.v4 
```

add these rules to this file

```
-A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
-A INPUT -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT
```

`ctrl+x` then press `Y` and `ENTER` to save the changes

apply the changes

```bash
sudo iptables-restore < /etc/iptables/rules.v4
```

### code-server

default port is 8080.

[install code-server](https://coder.com/docs/code-server/latest/install)

```bash
curl -fsSL https://code-server.dev/install.sh | sh
```

if you want to use it in the background

```bash
sudo systemctl enable --now code-server@$USER
```

#### config the password

```bash
nano ~/.config/code-server/config.yaml
```

#### set default python interpreter

Set python of conda base as default python interpreter.

`settings.json` (workspace or user)

```json
  "python.defaultInterpreterPath": "home/ubuntu/miniconda3/bin/python",
```

### RStudio Server

default port is 8787.

[Tutorial of installing R](bio-on-arm-linux.md#r)

- for amd64: [RStudio Server](https://www.rstudio.com/products/rstudio/download-server/)
- for arm64: [pre-release version](https://dailies.rstudio.com/)

```bash
sudo apt install gdebi-core
```

```bash
sudo gdebi <package.deb>
```

### Config Nginx and SSL

[code-server docs](https://coder.com/docs/code-server/latest/guide#using-lets-encrypt-with-nginx)

```bash
sudo apt update
sudo apt install -y nginx certbot python3-certbot-nginx
```

```bash
sudo nano /etc/nginx/sites-available/code-server
```

```bash
server { # for code-server
    listen 80;
    listen [::]:80;
    server_name mydomain.com; # like code.ddns.us

    location / {
      proxy_pass http://localhost:8080/;
      proxy_http_version 1.1;
      proxy_set_header Host $host;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection upgrade;
      proxy_set_header Accept-Encoding gzip;
    }
}

server { # for RStudio
    listen 80;
    listen [::]:80;
    server_name mydomain.com; # like r.ddns.us

    location / {
      proxy_pass http://localhost:8787/;
      
      proxy_set_header Host $host;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection upgrade;
      proxy_set_header Accept-Encoding gzip;
    }
}
```

Be sure to replace `mydomain.com` with your domain name!

```bash
sudo ln -s ../sites-available/code-server /etc/nginx/sites-enabled/code-server
sudo certbot --non-interactive --redirect --agree-tos --nginx -d code.mydomain.com -m me@example.com
sudo certbot --non-interactive --redirect --agree-tos --nginx -d r.mydomain.com -m me@example.com
```

# Trouble Shooting

## Too many redirects (When you use Cloudflare DNS)

https://stackoverflow.com/a/60789055/3858492

> In my case it was Cloudflare. I had to change to Full SSL encryption

# References

1. https://blogs.oracle.com/developers/post/enabling-network-traffic-to-ubuntu-images-in-oracle-cloud-infrastructure
2. https://coder.com/docs/code-server/latest/install
3. https://coder.com/docs/code-server/latest/guide#using-lets-encrypt-with-nginx
4. https://github.com/rstudio/rstudio/issues/8809#issuecomment-1224856044
