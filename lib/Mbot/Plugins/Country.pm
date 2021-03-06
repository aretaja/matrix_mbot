package Mbot::Plugins::Country;
use strict;
use warnings;


our $VERSION = '0.3';

=head1 NAME

Mbot::Plugins::Country - Mbot TLD country plugin

=head1 METHODS

=head2 parse - input parser

Responds TLD country name. (fe. country EE)

       $result = parse($self->in);

=cut

sub parse
{
    my ($self, $in) = @_;

    return 'country <DOMAIN> - responds TLD country name. (fe. country EE)'
      if ($in->{msg} && $in->{msg} eq 'help');

    my (@parts);
    if ($in->{msg} && $in->{msg} =~ m/^country\s+(.*)?\s*/)
    {
        my $code      = uc($1);
        my $countries = {
            'AC'   => 'Ascension Island',
            'AD'   => 'Andorra',
            'AE'   => 'United Arab Emirates',
            'AERO' => 'Aerospace industries (second wave of TLDs)',
            'AF'   => 'Afghanistan',
            'AG'   => 'Antigua and Barbuda',
            'AI'   => 'Anguilla',
            'AL'   => 'Albania',
            'AM'   => 'Armenia',
            'AN'   => 'Netherlands Antilles',
            'AO'   => 'Angola',
            'AQ'   => 'Antarctica',
            'AR'   => 'Argentina',
            'ARPA' => 'Reverse DNS',
            'AS'   => 'American Samoa',
            'AT'   => 'Austria',
            'ATO'  => 'Nato Fiel',
            'AU'   => 'Australia',
            'AW'   => 'Aruba',
            'AZ'   => 'Azerbaijan',
            'BA'   => 'Bosnia and Herzegovina',
            'BB'   => 'Barbados',
            'BD'   => 'Bangladesh',
            'BE'   => 'Belgium',
            'BF'   => 'Burkina Faso',
            'BG'   => 'Bulgaria',
            'BH'   => 'Bahrain',
            'BI'   => 'Burundi',
            'BIZ'  => 'Business (second wave of TLDs)',
            'BJ'   => 'Benin',
            'BM'   => 'Bermuda',
            'BN'   => 'Brunei Darussalam',
            'BO'   => 'Bolivia',
            'BR'   => 'Brazil',
            'BS'   => 'Bahamas',
            'BT'   => 'Bhutan',
            'BV'   => 'Bouvet Island',
            'BW'   => 'Botswana',
            'BY'   => 'Belarus',
            'BZ'   => 'Belize',
            'CA'   => 'Canada',
            'CC'   => 'Cocos Islands',
            'CF'   => 'Central African Republic',
            'CG'   => 'Congo',
            'CH'   => 'Switzerland',
            'CI'   => 'Cote D\'ivoire',
            'CK'   => 'Cook Islands',
            'CL'   => 'Chile',
            'CM'   => 'Cameroon',
            'CN'   => 'China',
            'CO'   => 'Colombia',
            'COM'  => 'Internic Commercial',
            'CR'   => 'Costa Rica',
            'CS'   => 'Former Czechoslovakia',
            'CU'   => 'Cuba',
            'CV'   => 'Cape Verde',
            'CX'   => 'Christmas Island',
            'CY'   => 'Cyprus',
            'CZ'   => 'Czech Republic',
            'DE'   => 'Germany',
            'DJ'   => 'Djibouti',
            'DK'   => 'Denmark',
            'DM'   => 'Dominica',
            'DO'   => 'Dominican Republic',
            'DZ'   => 'Algeria',
            'EC'   => 'Ecuador',
            'EDU'  => 'Educational Institution',
            'EE'   => 'Estonia',
            'EG'   => 'Egypt',
            'EH'   => 'Western Sahara',
            'ER'   => 'Eritrea',
            'ES'   => 'Spain',
            'ET'   => 'Ethiopia',
            'EU'   => 'EUropean Union',
            'FI'   => 'Finland',
            'FJ'   => 'Fiji',
            'FK'   => 'Falkland Islands',
            'FM'   => 'Micronesia',
            'FO'   => 'Faroe Islands',
            'FR'   => 'France',
            'FX'   => 'France Metropolitan',
            'GA'   => 'Gabon',
            'GB'   => 'Great Britain',
            'GD'   => 'Grenada',
            'GE'   => 'Georgia',
            'GF'   => 'French Guiana',
            'GH'   => 'Ghana',
            'GI'   => 'Gibraltar',
            'GL'   => 'Greenland',
            'GM'   => 'Gambia',
            'GN'   => 'Guinea',
            'GOV'  => 'Government',
            'GP'   => 'Guadeloupe',
            'GQ'   => 'Equatorial Guinea',
            'GR'   => 'Greece',
            'GS'   => 'S. Georgia and S. Sandwich Isles.',
            'GT'   => 'Guatemala',
            'GU'   => 'Guam',
            'GW'   => 'Guinea-Bissau',
            'GY'   => 'Guyana',
            'HK'   => 'Hong Kong',
            'HM'   => 'Heard and McDonald Islands',
            'HN'   => 'Honduras',
            'HR'   => 'Croatia',
            'HT'   => 'Haiti',
            'HU'   => 'Hungary',
            'ID'   => 'Indonesia',
            'IE'   => 'Ireland',
            'IL'   => 'Israel',
            'IN'   => 'India',
            'INFO' => 'Info (second wave of TLDs)',
            'INT'  => 'International',
            'IO'   => 'British Indian Ocean Territory',
            'IQ'   => 'Iraq',
            'IR'   => 'Iran',
            'IS'   => 'Iceland',
            'IT'   => 'Italy',
            'JM'   => 'Jamaica',
            'JO'   => 'Jordan',
            'JP'   => 'Japan',
            'KE'   => 'Kenya',
            'KG'   => 'Kyrgyzstan',
            'KH'   => 'Cambodia',
            'KI'   => 'Kiribati',
            'KM'   => 'Comoros',
            'KN'   => 'St. Kitts and Nevis',
            'KP'   => 'North Korea',
            'KR'   => 'South Korea',
            'KW'   => 'Kuwait',
            'KY'   => 'Cayman Islands',
            'KZ'   => 'Kazakhstan',
            'LA'   => 'Laos',
            'LB'   => 'Lebanon',
            'LC'   => 'Saint Lucia',
            'LI'   => 'Liechtenstein',
            'LK'   => 'Sri Lanka',
            'LR'   => 'Liberia',
            'LS'   => 'Lesotho',
            'LT'   => 'Lithuania',
            'LU'   => 'Luxembourg',
            'LV'   => 'Latvia',
            'LY'   => 'Libya',
            'MA'   => 'Morocco',
            'MC'   => 'Monaco',
            'MD'   => 'Moldova',
            'MED'  => 'United States Medical',
            'MG'   => 'Madagascar',
            'MH'   => 'Marshall Islands',
            'MIL'  => 'Military',
            'MK'   => 'Macedonia',
            'ML'   => 'Mali',
            'MM'   => 'Myanmar',
            'MN'   => 'Mongolia',
            'MO'   => 'Macau',
            'MP'   => 'Northern Mariana Islands',
            'MQ'   => 'Martinique',
            'MR'   => 'Mauritania',
            'MS'   => 'Montserrat',
            'MT'   => 'Malta',
            'MU'   => 'Mauritius',
            'MV'   => 'Maldives',
            'MW'   => 'Malawi',
            'MX'   => 'Mexico',
            'MY'   => 'Malaysia',
            'MZ'   => 'Mozambique',
            'NA'   => 'Namibia',
            'NC'   => 'New Caledonia',
            'NE'   => 'Niger',
            'NET'  => 'Internic Network',
            'NF'   => 'Norfolk Island',
            'NG'   => 'Nigeria',
            'NI'   => 'Nicaragua',
            'NL'   => 'Netherlands',
            'NO'   => 'Norway',
            'NP'   => 'Nepal',
            'NR'   => 'Nauru',
            'NT'   => 'Neutral Zone',
            'NU'   => 'Niue',
            'NZ'   => 'New Zealand',
            'OM'   => 'Oman',
            'ORG'  => 'Internic Non-Profit Organization',
            'PA'   => 'Panama',
            'PE'   => 'Peru',
            'PF'   => 'French Polynesia',
            'PG'   => 'Papua New Guinea',
            'PH'   => 'Philippines',
            'PK'   => 'Pakistan',
            'PL'   => 'Poland',
            'PM'   => 'St. Pierre and Miquelon',
            'PN'   => 'Pitcairn',
            'PR'   => 'Puerto Rico',
            'PT'   => 'Portugal',
            'PW'   => 'Palau',
            'PY'   => 'Paraguay',
            'QA'   => 'Qatar',
            'RE'   => 'Reunion',
            'RO'   => 'Romania',
            'RPA'  => 'Old School ARPAnet',
            'RS'   => 'Serbia',
            'RU'   => 'Russian Federation',
            'RW'   => 'Rwanda',
            'SA'   => 'Saudi Arabia',
            'SC'   => 'Seychelles',
            'SD'   => 'Sudan',
            'SE'   => 'Sweden',
            'SG'   => 'Singapore',
            'SH'   => 'St. Helena',
            'SI'   => 'Slovenia',
            'SJ'   => 'Svalbard and Jan Mayen Islands',
            'SK'   => 'Slovak Republic',
            'SL'   => 'Sierra Leon',
            'SM'   => 'San Marino',
            'SN'   => 'Senegal',
            'SO'   => 'Somalia',
            'SR'   => 'Suriname',
            'ST'   => 'Sao Tome and Principe',
            'SU'   => 'Former USSR',
            'SV'   => 'El Salvador',
            'SY'   => 'Syria',
            'SZ'   => 'Swaziland',
            'Sb'   => 'Solomon Islands',
            'TC'   => 'Turks and Caicos Islands',
            'TD'   => 'Chad',
            'TF'   => 'French Southern Territories',
            'TG'   => 'Togo',
            'TH'   => 'Thailand',
            'TJ'   => 'Tajikistan',
            'TK'   => 'Tokelau',
            'TM'   => 'Turkmenistan',
            'TN'   => 'Tunisia',
            'TO'   => 'Tonga',
            'TP'   => 'East Timor',
            'TR'   => 'Turkey',
            'TT'   => 'Trinidad and Tobago',
            'TV'   => 'Tuvalu',
            'TW'   => 'Taiwan',
            'TZ'   => 'Tanzania',
            'UA'   => 'Ukraine',
            'UG'   => 'Uganda',
            'UK'   => 'United Kingdom',
            'UM'   => 'US Minor Outlying Islands',
            'US'   => 'United States of America',
            'UY'   => 'Uruguay',
            'UZ'   => 'Uzbekistan',
            'VA'   => 'Vatican City State',
            'VC'   => 'St. Vincent and the grenadines',
            'VE'   => 'Venezuela',
            'VG'   => 'British Virgin Islands',
            'VI'   => 'US Virgin Islands',
            'VN'   => 'Vietnam',
            'VU'   => 'Vanuatu',
            'WF'   => 'Wallis and Futuna Islands',
            'WS'   => 'Samoa',
            'XXX'  => 'Porn (third wave of TLDs)',
            'YE'   => 'Yemen',
            'YT'   => 'Mayotte',
            'YU'   => 'Yugoslavia',
            'ZA'   => 'South Africa',
            'ZM'   => 'Zambia',
            'ZR'   => 'Zaire',
            'ZW'   => 'Zimbabwe',
        };

        return ($countries->{$code})
          ? "$code - $countries->{$code}"
          : "$code - unknown";
    }
}

1;

__END__

=head1 AUTHOR

Marko Punnar <marko@aretaja.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2018 by Marko Punnar.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see L<http://www.gnu.org/licenses/>

=cut
