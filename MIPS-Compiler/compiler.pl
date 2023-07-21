#!/usr/bin/perl

use warnings;
use strict;
use bigint;

my $Address  		= 0x00400000;
my $MIPS_FILE  		= 'MIPS.asm';
my $TEMP_FILE 	 	= 'TEMP.txt';
my $TEMP_1_FILE  	= 'TEMP(1).txt';
my $DATA_FILE 		= 'DATA.bin';
my $TEXT_FILE 		= 'TEXT.bin';
my $IS_DATA 		= 0;	

open(MIPS, '<', $MIPS_FILE) or die $!;
open(TEMP, '>'.$TEMP_FILE) or die $!;
open(TEMP_1, '>'.$TEMP_1_FILE) or die $!;
open(TEXTSEGMENT_OUT, '>'.$TEXT_FILE) or die $!;
open(DATASEGMENT_OUT, '>'.$DATA_FILE) or die $!;

my %label;
my %instruction_address;

while (<MIPS>){
	$_ =~ s/[\t\r]+//g;
	my $comment_cha = '#';
	my $label_cha = ':';
	my $temp = '';
	my $index_fix = 0;
	my $index_compare = 0;
	my $index_of_space = 0;
	if (index($_, ".data") != -1) {
		$IS_DATA = 1;
		next;
	}
		
	elsif (index($_, ".text") != -1) {
		$IS_DATA = 0;
		next;
	}
		
	if ($IS_DATA == 1) {
		while (1) {
			if ($index_fix  != 0) {
				$index_of_space = index($_, ' ', $index_fix );
				$index_compare = index($_, ' ', $index_fix ) + 1;
			}

			while (substr($_, $index_compare, 1) eq ' ') {
				substr($_, $index_of_space, 1, '');
			}

			$index_fix = $index_fix  + 1;
			last if (index($_, ' ', $index_fix ) == -1);
		}
		
		while (1) {
			$index_of_space = rindex($_, ' ');
			last if (substr($_, $index_of_space, 0) ne ' ');
			substr($_, $index_of_space, 1, '');
		}
		
		if (!($_ =~ /^\s*$/)){
			if (index($_, $label_cha) != -1 ) {
				if(substr($_, index($_, ' '), 1) eq "\n"){
					next;
				}

				else {
					my $start = index($_, $label_cha) + 3;
					my $cur = length($_) - 1;
					$temp = substr($_, $start, $cur);
					print TEMP_1 ($temp)
				}
			}

			else {
				print TEMP_1;
			}
		}
	}

	else {
		while (1) {
			if ($index_fix  != 0) {
				$index_of_space = index($_, ' ', $index_fix );
				$index_compare = index($_, ' ', $index_fix ) + 1;
			}

			while (substr($_, $index_compare, 1) eq ' ') {
				substr($_, $index_of_space, 1, '');
			}

			$index_fix  = $index_fix  + 1;
			last if (index($_, ' ', $index_fix ) == -1);
		}
		
		while (1) {
			$index_of_space = rindex($_, ' ');
			last if (substr($_, $index_of_space, 0) ne ' ');
			substr($_, $index_of_space, 1, '');
		}

		next if (index($_, $comment_cha) == 0);

		if (!($_ =~ /^\s*$/)){
			if (index($_, $comment_cha) != -1) {
				my $cur = index($_, $comment_cha);
				$temp = substr($_, 0, $cur - 1);
				
				substr($temp, length($temp), 0, "\n");
				$instruction_address{$temp} = $Address;
				$Address = $Address + 0x4;
				
				print TEMP ($temp)
			}

			else {
				if (index($_, $label_cha) != -1 ) {
					if(substr($_, index($_, ' '), 1) eq "\n"){
						chop($_);
						chop($_);
						$label{$_} = $Address;
					}

					else {
						my $cur = index($_, $label_cha);
						$label{substr($_, 0, $cur)} = $Address;
						
						my $start = $cur + 2;
						$cur = length($_) - 1;
						$temp = substr($_, $start, $cur);
						
						$instruction_address{$temp} = $Address;
						$Address = $Address + 0x4;
						print TEMP ($temp)
					}
				}

				else {
					$instruction_address{$_} = $Address;
					$Address = $Address + 0x4;
					print TEMP;
				}
			}
		}
	} 
}

close(MIPS);
close(TEMP);
close(TEMP_1);
open(FILE, '<', $TEMP_FILE) or die $!;
my %reg = ( 
	'$0' 	=> '00000',
	'$zero' => '00000',
	'$at'   => '00001',
	'$v0'   => '00010',
	'$v1'   => '00011',
	'$a0'   => '00100',
	'$a1'   => '00101',
	'$a2'   => '00110',
	'$a3'   => '00111',
	'$t0'   => '01000',
	'$t1'   => '01001',
	'$t2'   => '01010',
	'$t3'   => '01011',
	'$t4'   => '01100',
	'$t5'   => '01101',
	'$t6'   => '01110',
	'$t7'   => '01111',
	'$s0'   => '10000',
	'$s1'   => '10001',
	'$s2'   => '10010',
	'$s3'   => '10011',
	'$s4'   => '10100',
	'$s5'   => '10101',
	'$s6'   => '10110',
	'$s7'   => '10111',
	'$t8'   => '11000',
	'$t9'   => '11001',
	'$k0'   => '11010',
	'$k1'   => '11011',
	'$gp'   => '11100',
	'$sp'   => '11101',
	'$fp'   => '11110',
	'$ra'   => '11111',
);

my %opcode = (
	'add' 	=> '000000',
	'addi' 	=> '001000',
	'addiu' => '001001',
	'addu' 	=> '000000',
	'and' 	=> '000000',
	'andi' 	=> '001100',
	'beq' 	=> '000100',
	'bne' 	=> '000101',
	'j' 	=> '000010',
	'jal' 	=> '000011',
	'jr' 	=> '000000',
	'lbu' 	=> '100100',
	'lhu'	=> '100101',
	'lui' 	=> '001111',
	'll' 	=> '110000',
	'lw' 	=> '100011',
	'sw' 	=> '101011',
);

my %func = (
	'add' 	=> '100000',
	'addu' 	=> '100001',
	'and' 	=> '100100',
	'jr' 	=> '001000',
);

my @I_Reg_Type  	= qw(addi addiu andi);
my @I_Label_Type 	= qw(beq bne);
my @I_LS_Type 		= qw(lbu lhu lui ll lw sw);
my @R_Type  		= qw(add addu and jr);
my @J_Type 	 	= qw(j jal);

print ("Copy sucessfully!!! \n");

while (<FILE>) {
	my $space  = ' ';
	my $comma  = ',';
	my $bracket_front  = '(';
	my $bracket_back  = ')';
	my $text_line  = $_;
	my $instruction  = substr($text_line, 0, index($text_line, $space));

	print TEXTSEGMENT_OUT $opcode{$instruction};

	for (@I_Reg_Type) {
		if ($_ eq $instruction){
			my $cur = index($text_line, $comma);
			my $start = index($text_line, $space) + 1;
			my $reg_rt = $reg{substr($text_line, $start, $cur - $start)};

			$start = $cur + 2;
			$cur = rindex($text_line, $comma);
			my $reg_rs = $reg{substr($text_line, $start, $cur - $start)};

			$start = $cur + 2;
			$cur = length($text_line) - 1;
			my $immediate = sprintf ("%b", substr($text_line, $start, $cur - $start)); 

			if (length($immediate) > 16) {
				substr($immediate, 0, length($immediate) - 16, '');
			}

			else{
				while (length($immediate) < 16){
					substr($immediate, 0, 0, '0');
				}
			}

			print TEXTSEGMENT_OUT ($reg_rs, $reg_rt, $immediate, "\n");

			last;
		}
	}

	for (@I_Label_Type) {
		if ($_ eq $instruction){
			my $cur = index($text_line, $comma);
			my $start = index($text_line, $space) + 1;
			my $reg_rs = $reg{substr($text_line, $start, $cur - $start)};

			$start = $cur + 2;
			$cur = rindex($text_line, $comma);
			my $reg_rt  = $reg{substr($text_line, $start, $cur - $start)};

			$start = $cur + 2;
			$cur = length($text_line) - 1;
			my $offset = ($label{substr($text_line, $start, $cur - $start)} - $instruction_address{$text_line}) / 4;
			my $label_addr = sprintf("%b", $offset - 1); 

			if (length($label_addr) > 16) {
				substr($label_addr, 0, length($label_addr) - 16, '');
			}

			else{
				while (length($label_addr) < 16){
					substr($label_addr, 0, 0, '0');
				}
			}

			print TEXTSEGMENT_OUT ($reg_rs, $reg_rt, $label_addr, "\n");

			last;
		}
	}
	for (@I_LS_Type) {
		if ($_ eq $instruction){
			my $cur = index($text_line, $comma);
			my $start = index($text_line, $space) + 1;
			my $reg_rt = $reg{substr($text_line, $start, $cur - $start)};
			my $immediate = 0;
			my $reg_rs = '00000';

			if (index($text_line, $bracket_front) != -1) {
				$start = $cur + 2;
				my $character = substr($text_line, $start, 1);

				if (!($character eq $bracket_front)){ 
					if ($character eq '-'){
						$immediate = substr($text_line, $start, 2);
						$start = $start + 2;
					}

					else {
						$immediate = $character;
						$start = $start + 1;
					}
				}

				$start = $start + 1;
				$cur = index($text_line, $bracket_back);
				$reg_rs = $reg{substr($text_line, $start, $cur - $start)};
			}

			else { 
				$start = $cur + 2;
				$immediate = substr($text_line, $start, 1);
			}

			$immediate = sprintf ("%b", $immediate); 

			if (length($immediate) > 16) {
				substr($immediate, 0, length($immediate) - 16, '');
			}

			else {
				while (length($immediate) < 16){
					substr($immediate, 0, 0, '0');
				}
			}

			print TEXTSEGMENT_OUT ($reg_rs, $reg_rt, $immediate, "\n");

			last;
		}
	}

	for (@R_Type) {
		my $reg_rs  = '00000' ;
		my $reg_rt = '00000' ;
		my $reg_rd = '00000' ; 
		my $reg_shamt = '00000' ;
		my $reg_func = '000000';

		if ($_ eq $instruction){
			if ($instruction eq "jr") {
				my $start = index($text_line, $space) + 1;
				my $cur = length($text_line) - 1;
				$reg_rs = $reg{substr($text_line, $start, $cur - $start)};

				$reg_func = $func{$instruction};

				print TEXTSEGMENT_OUT ($reg_rs, $reg_rt, $reg_rd, $reg_shamt, $reg_func, "\n");
			}

			else {
				my $cur = index($text_line, $comma);
				my $start = index($text_line, $space) + 1;
				$reg_rd = $reg{substr($text_line, $start, $cur - $start)};

				$start = $cur + 2;
				$cur = rindex($text_line, $comma);
				$reg_rs  = $reg{substr($text_line, $start, $cur - $start)};

				$start = $cur + 2;
				$cur = length($text_line) - 1;
				$reg_rt = $reg{substr($text_line, $start, $cur - $start)};

				$reg_func = $func{$instruction};

				print TEXTSEGMENT_OUT ($reg_rs, $reg_rt, $reg_rd, $reg_shamt, $reg_func, "\n");
			}

			last;
		}
	}
	for (@J_Type) {
		if ($_ eq $instruction){
			my $start = index($text_line, $space) + 1;
			my $cur = length($text_line) - 1;
			my $label_address = $label{substr($text_line, $start, $cur - $start)} >> 2;

			$label_address = sprintf("%b", $label_address);

			while (length($label_address) < 26){
				substr($label_address, 0, 0, '0');
			}

			print TEXTSEGMENT_OUT ($label_address, "\n");

			last;
		}
	}
}


close(FILE);
#unlink $TEMP_FILE;
close(TEXTSEGMENT_OUT);


open(DATA_FILE, '<', $TEMP_1_FILE) or die $!;
my $data_address 	= 0x10010000;
my $remember 		= '';
	
while (<DATA_FILE>){
	my $data_line = $_;
	my $index_of_space = index($data_line, ' ');
	my $type_of_data = substr($data_line, 0, $index_of_space);
	my $data = substr($data_line, $index_of_space + 1, length($data_line) - ($index_of_space + 1) - 1);

	if (index($data, '"') != -1) {
		substr($data, 0, 1, '');
	}

	my $temp_data = '';
	my $i = 0;
	my $j = 0;

	if ($type_of_data eq "asciiz") {
		while (1) {
			$j = 0;
			
			if ($remember ne '') {
				$temp_data = substr($data, 0, 4 - length($remember));
				$temp_data = $remember.$temp_data;
				
				while ($j < 4) {
					my $last_key = chop($temp_data);

					if ($last_key eq '"'){
						$last_key = '';
					}
						
					$last_key = sprintf ("%b", ord(chop($last_key)));
					
					while (length($last_key) < 8) {
						substr($last_key, 0, 0, '0');
					}
					
					print DATASEGMENT_OUT ($last_key);
					$j += 1;
				}
				
				$i += 4 - length($remember);
				$remember = '';
				$data_address += 0x4;
			}
			
			else {
				last if ($i > length($data) - 1);
				$temp_data = substr($data, $i, 4);
				
				if (length($temp_data) < 4) {
					$remember = $temp_data;
					last;
				}
				
				else {
					while ($j < 4) {
						my $last_key = chop($temp_data);

						if ($last_key eq '"'){
							$last_key = '';
						}
						
						$last_key = sprintf ("%b", ord($last_key));

						while (length($last_key) < 8) {
							substr($last_key, 0, 0, '0');
						}
						
						print DATASEGMENT_OUT ($last_key);
						$j += 1;
					}
					
					$data_address += 0x4;
				}
				
				$i += 4;
			}
			
			if ($data_address % 0x2 == 0) {
				print DATASEGMENT_OUT ("\n");
			}
		}
	}
	
	elsif ($type_of_data eq "byte") {
		while (index($data, ' ') != -1){
			substr($data, index($data, ' '), 1, '');
		}
		
		while (1) {
			$j = 0;
			
			if ($remember ne '') {
				$temp_data = substr($data, 0, 4 - length($remember));
				$temp_data = $remember.$temp_data;
				while ($j < 4) {
					my $last_key = chop($temp_data);

					if ($last_key eq '"'){
						$last_key = '';
					}
					
					if ($j < 4 - length($remember)) {
						$last_key = sprintf ("%b", chop($last_key));
					}
					
					else {
						$last_key = sprintf ("%b", ord(chop($last_key)));
					}
					
					while (length($last_key) < 8) {
						substr($last_key, 0, 0, '0');
					}
					
					print DATASEGMENT_OUT ($last_key);
					$j += 1;
				}
				
				$i += 4 - length($remember);
				$remember = '';
				$data_address += 0x4;
			}
			
			else {
				last if ($i > length($data) - 1);
				$temp_data = substr($data, $i, 4);
				
				if (length($temp_data) < 4) {
					$remember = $temp_data;
					last;
				}
				
				else {
					while ($j < 4) {
						my $last_key = chop($temp_data);

						if ($last_key eq '"'){
							$last_key = '';
						}
						
						$last_key = sprintf ("%b", $last_key);

						while (length($last_key) < 8) {
							substr($last_key, 0, 0, '0');
						}
						
						print DATASEGMENT_OUT ($last_key);
						$j += 1;
					}
					
					$data_address += 0x4;
				}
				
				$i += 4;
			}
			
			if ($data_address % 0x2 == 0) {
				print DATASEGMENT_OUT ("\n");
			}
		}
	}
	
	elsif ($type_of_data eq 'word'){
		while (index($data, ' ') != -1){
			substr($data, index($data, ' '), 1, '');
		}

		while (length($data) != 0) {
			$j = 0;
			if ($remember ne '') {
				$temp_data = $remember;
				while (length($temp_data) != 4) {
					substr($temp_data, length($temp_data), 0, '0');
				}
				
				while ($j < 4) {
					my $last_key = chop($temp_data);
					
					$last_key = sprintf ("%b", chop($last_key));
					
					while (length($last_key) < 8) {
						substr($last_key, 0, 0, '0');
					}
					
					print DATASEGMENT_OUT ($last_key);
					$j += 1;
				}
				
				$i += 4 - length($remember);
				$remember = '';
				$data_address += 0x4;
			}
			
			else {
				my $last_key = substr($data, 0, 1);
				$last_key = sprintf ("%b", $last_key);
					
				while (length($last_key) < 32) {
					substr($last_key, 0, 0, '0');
				}
				
				print DATASEGMENT_OUT ($last_key);
				substr($data, 0, 1, '');
				$data_address += 0x4;
			}
			
			if ($data_address % 0x2 == 0) {
				print DATASEGMENT_OUT ("\n");
			}
		}
	} 
}

my $free_line = '';
while (length($free_line) < 32) {
	substr($free_line, 0, 0, '0');
}
	
while ($data_address < 0x10011000) {
	print DATASEGMENT_OUT ($free_line, "\n");
	$data_address += 0x4;
}

print ("Convert sucessfully!!! \n");
close(DATA_FILE);
unlink $TEMP_1_FILE;
close(DATASEGMENT_OUT);
