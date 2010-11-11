require 5.008;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'	   => 'Encode::Locale',
    'VERSION_FROM' => 'lib/Encode/Locale.pm',
    'PREREQ_PM'    => {
	'Encode' => 2,
	'Encode::Alias' => 0,
	'I18N::Langinfo' => 0,
    },
);
