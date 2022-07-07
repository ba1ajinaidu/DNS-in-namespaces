;
; BIND data file for local loopback interface
;
$TTL	604800
@	IN	SOA	x.gtld-server.tcl. admin.test.tcl. (
			      3		; Serial
			 604800		; Refresh
			  86400		; Retry
			2419200		; Expire
			 604800 )	; Negative Cache TTL
;
; name servers - NS records
     IN      NS      x.gtld-server.tcl.
x.gtld-server.tcl. IN A 10.0.0.3

