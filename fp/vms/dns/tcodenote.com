;
; BIND data file for local loopback interface
;
$TTL	604800
@	IN	SOA	tcodenote.com. root.tcodenote.com. (
			      2		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			 604800 )	; Negative Cache TTL
;
@	IN	NS	tcodenote.com.
@	IN	A	10.11.12.2
*	IN	A	10.11.12.2
