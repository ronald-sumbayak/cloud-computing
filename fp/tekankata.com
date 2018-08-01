;
; BIND data file for local loopback interface
;
$TTL	604800
@	IN	SOA	tekankata.com. root.tekankata.com. (
			      2		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			 604800 )	; Negative Cache TTL
;
@	IN	NS	tekankata.com.
@       IN      A       11.12.13.14
