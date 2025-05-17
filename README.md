# TaurusVPN
You can set up your own private VPN server, dedicated for serving only your devices at a very cheap price. You can use popular and cheap cloud computes instances like aws ec2, google cloud compute engine etc. You only need 1 Gb memory and 2 vCPUs for most usage patterns. The below setup is for debian. The setup may vary for other distros. But the general steps are the same

**Recommended server requirements (for one VPN client)**
- 2 vCPU (3 if you want to overprovision)
- 1 Gb (more than enough to stream 4k)
- 8 Gb disk space (only 3.6 Gb utilized for Debian OS+Wireguard)
- Static IP (or ddns service like Duck DNS)

**Step 1: Install wireguard on server**
```sh
sudo apt install wireguard -y
```

**Step 2: Generate keys on server**
This step generate both clientside and server side keys
```sh
wg genkey | tee server_private | wg pubkey > server_public
wg genkey | tee client_private | wg pubkey > client_public
```

**Step 3: Configure serverside**
1. Make sure server firewall rules allows outbound traffic to public internet and inbound traffic to UDP port 51820
1. Copy `server.conf` and paste it in `/etc/wireguard/wg0.conf`
2. Start server: `sudo wg-quick up wg0`
3. Enable as service: `sudo systemctl enable wg-quick@wg0`
4. Verify using: `sudo wg show`

**Step 4: Configure clientside**
1. Install VPN tunnelling apps like wireguard from play store
2. Import the `client.conf` into the app

And that's it. You VPN is now up and running

## Performance

Here's the download speed test result of this setup on google cloud e2.micro (2 vcpu; 1 Gb) standard network tier instance running debian:

| Without VPN | \*TaurusVPN\* | Opera VPN | Turbo VPN  |
|-------------|---------------|-----------|------------|
| 162.4 Mbps  | 61.1 Mbps (Oregon)   | 3.09 Mbps (America) | 6.79 Mbps (San Jose) |

(Benchmarking done using [M-Lab](https://www.measurementlab.net/about/) powered tool, from UTC+05:30 timezone)

It goes without saying how fast a personal VPN server can be with just 1 GB of RAM. It is reliable and cheap as well. If you shutdown the server when not in use and use spot instances, you bills could be as low as US **$0.03 per month**. Even if you choose not to shutdown the server, running a e2.micro 24/7 only cost less than $4.27 per month (using spot VM)

## FAQs

#### Are personal VPN servers worth it?
It depends. Personal servers are mostly intended for hobbyists, who are willing to spare some loose change for their own private virtual server. For most people, it is an overkill. Here's the pros and cons: 

**Pros**
- Higher speed (~50 Mbps) than most VPN services (~5 Mbps)
- No ads
- Bills as low as $0.03/month

**Cons**
- Manually start server every time (5-10 seconds boot time for E2.micro spot)
- Only one VPN location for each server you setup
- Hard to setup initially

#### How much are the cloud bills
If you diligently shut down the server when not in use, running the server for 20 minutes a day on GCP, the bills could be as low as US **$0.03** for a whole month (seriously). But if you keep it running 24/7, the bills could still be cheap (about $4.27), if you use the cheapest configuration in you cloud service provider (like using micro instances)

You can estimate your cloud bills using [Google cloud pricing calculator](https://cloud.google.com/products/calculator) or [AWS pricing calculator](https://calculator.aws/)
