# TaurusVPN
You can set up your own private VPN server, dedicated for serving your devices at a very cheap price. You can use popular and cheap cloud computes instances like aws ec2, google cloud compute engine etc. You only need 1 Gb memory and 2 vCPUs for most usage patterns. The below setup is for debian. The setup may vary for other distros. But the general steps are the same

### Step 1: Install wireguard on server
```sh
sudo apt install wireguard -y
```

### Step 2: Generate keys on server
This step generate both clientside and server side keys
```sh
wg genkey | tee server_private | wg pubkey > server_public
wg genkey | tee client_private | wg pubkey > client_public
```

### Step 3: Configure serverside
1. Make sure server firewall rules allows outbound traffic to public internet and inbound traffic to UDP port 51820
1. Copy `server.conf` and paste it in `/etc/wireguard/wg0.conf`
2. Start server: `sudo wg-quick up wg0`
3. Enable as service: `sudo systemctl enable wg-quick@wg0`
4. Verify using: `sudo wg show`

### Step 4: Configure clientside
1. Install VPN tunnelling apps like wireguard from play store
2. Import the `client.conf` into the app

And that's it. You VPN is now up and running

## Performance

Here's the download speed test result of this setup on google cloud e2.micro (2 vcpu; 1 Gb) standard network tier instance running debian:

| Without VPN | \*TaurusVPN\* | Opera VPN | Turbo VPN  |
|-------------|---------------|-----------|------------|
| 162.4 Mbps  | 49.1 Mbps     | 3.09 Mbps | 132.3 Mbps |

Obviously this setup is not the fastest. Its not even close to the whopping 132.3 Mbps download rate of TurboVPN. But it doesn't show you any ads. Its reliable. Every aspect of the server are in your control and its super cheap. If you shutdown the server when not in use and use spot instances, you bills could be as low as US $0.07 per month. Even if you choose not to shutdown the server, running a e2.micro 24/7 only cost less than $4.27 per month (using spot VM)

### FAQs

#### Are personal VPN servers worth it?
It depends. Personal servers are mostly intended for hobbyists, who are willing to spare some loose change for their own private virtual server. For most people, it is an overkill

- Yes, if you hate watching ads, but you are ok with going through the hassle of shutting down the server when not in use, and waiting 15-20 seconds for the server to boot up before connecting.
- No, if you are ok with ads and want multiple VPN location to choose from

However as far as I have noticed, paying for low end virtual server might often be cheaper that paying for a VPN premium ($4.27 for E2.micro vs $13.2 for TurboVPN). But these low end servers might not be so adept in continuous 4k streaming

#### How much are the cloud bills
If you diligently shut down the server when not in use, the bills cpuld be as low as US **$0.07** (seriously). But if you keep it running 24/7, the bills could still be cheap (about $4.27), if you use the cheapest configuration in you cloud service provider (like using micro instances)
