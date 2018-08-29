
#!/usr/bin/perl

use NetSNMP::agent (':all');
use NetSNMP::ASN;
use NetSNMP::OID;


sub hello_handler
{
	my ($handler, $registration_info, $request_info, $requests) = @_;
	my $request;
	for($request = $requests; $request; $request = $request->next()) 
	{
		my $oid = $request->getOID();
		my @oidarray = split/[.]/,$oid;
		my $lastoid = $oidarray[-1];
		if ($request_info->getMode() == MODE_GET)
		{
			if ($oid == new NetSNMP::OID("1.3.6.1.4.1.4171.40.1")) 
			{
				$request->setValue(ASN_COUNTER,time);
			}
			elsif ($oid > new NetSNMP::OID("1.3.6.1.4.1.4171.40.1"))
			{
				$t = time();
				my $key;
				my $value;
				my $result;
				my $file = '/tmp/A1/counters.conf';
				open my $info, $file or die "Could not open $file: $!";
				while( my $line = <$info>)  
				{   
				    ($key, $val) = split (",",$line);
				    if($key == $lastoid-1)
				    {
					$result = $val * $t;
					$request->setValue(ASN_COUNTER,$result);
					
				    }
				}
			}
				
			
			
		}

	}
}
my $agent = new NetSNMP::agent();
$agent->register("mohith", "1.3.6.1.4.1.4171.40", \&hello_handler);
