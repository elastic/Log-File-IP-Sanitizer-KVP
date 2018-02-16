#another IP Sanitizer by Roberto Seldner
#Syntax: ipscrub-kvp.sh /path/sourcefile
#Output will be in the sourcefile's directory

#The purpose of this script is to replace IPv4 addresses (and subnets) in a file, such as a syslog, with a random, unique, identifier.  This sanitizes a log while preserving some meaning/context.

#A recipient of such a file can then differentiate between endpoints in a log file, without disclosing their actual addresses.

#The script will create a randomized key-value pair from the IP addresses, then replace each IP with its corresponding key.  

#The order is randomized using sort -R; where the output order is determined by each line's hash value, derived from a randomly chosen hash function (where the seed = /dev/random) each time sort is invoked.  This method works for our purpose since each line is unique.

#To use perl's shuffle instead, uncomment the cat ... perl line, and comment the sort -R

#This description is longer than the script itself :]

Script Example

	:~ $ ~/temp/./ipscrub-kvp.sh ~/temp/hostcopy

		Sample Output of /home/user/hostcopy-scrubbed
			2-IPv4	localhost
			1-IPv4	broadcasthost
			2-IPv4 domain.local
			3-IPv4	blah.com

Contents of Output

##
# Host Database
#
# localhost is used to configure the loopback interface
# when the system is booting.  Do not change this entry.
##
2-IPv4	localhost
1-IPv4	broadcasthost
2-IPv4  domain.local
3-IPv4	blah.com
::1		localhost