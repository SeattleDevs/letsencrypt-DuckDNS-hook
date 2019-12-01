# DuckDNS hook for `dehydrated`

This is a hook for the [Let's Encrypt](https://letsencrypt.org/) ACME client [dehydrated](https://github.com/lukas2511/dehydrated) (previously known as `letsencrypt.sh`) that allows you to use [DuckDNS](https://www.DuckDNS.com/) [Specs](https://www.duckdns.org/spec.jsp) DNS records to respond to `dns-01` challenges. Requires bash and your DuckDNS account token being in the environment.

## Installation

```
$ cd ~
$ git clone https://github.com/lukas2511/dehydrated
$ cd dehydrated
$ mkdir hooks
$ git clone https://github.com/SeattleDevs/letsencrypt-DuckDNS-hook.git hooks/duckdns
```

## Configuration

Your DuckDNS token is expected to be in the environment.  If you do not have a token yet, go to [DuckDNS specs to learn more](https://www.duckdns.org/spec.jsp) and to obtain it.
If the token is not in the enviornment yet, set it up by the following commands in bash:

```
$ export DUCKDNS_TOKEN='example-token'
```

## Usage

```
$ ./dehydrated -c -d example.com -t dns-01 -k 'hooks/duckdns/hook.sh'
```
