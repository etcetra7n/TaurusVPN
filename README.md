# TaurusVPN
You can set up your own private VPN server, only for your devices for a very cheap price. You can use popular and cheap cloud computes instances like aws ec2, google cloud compute engine etc. You only need 1-2 Gb memory and 0.5-2 vCPUs. The below setup is for debian. The setup may vary for other distros. But the general steps are the same

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
3. Enable service: `sudo systemctl enable wg-quick@wg0`
4. Verify running: `sudo wg show`

### Step 4: Configure clientside
1. Install VPN tunnelling apps like wireguard from play store
2. Import the `client.conf` into the app

And that's it. You VPN is now up and running

## Performance

Here's the speed test result of this setup on google cloud e2.micro (2 vcpu; 1 Gb) instance running debian:

| Without VPN | TaurusVPN | COLUMN 3 |
|----------|----------|----------|
| 72.1 Mbps  | 46.0 Mbps     | More     |
