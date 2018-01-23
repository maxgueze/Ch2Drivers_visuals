setwd("C:/Users/maximilien.gueze/OneDrive - United Nations Development Programme/Mapping/Ch2_Drivers/Eduardo_materials/R")
library(downloader)

#OPEN FROM URL >DOESNT WORK!!!!

url<-"http://www.materialflows.net/mmm_vis/excel_mth.php?year_from=2013|2012|2011|2010|2009|2008|2007|2006|2005|2004|2003|2002|2001|2000|1999|1998|1997|1996|1995|1994|1993|1992|1991|1990|1989|1988|1987|1986|1985|1984|1983|1982|1981|1980&year_to=2013&flowtypeid=extr&extractionid=total&referenceid=abs&reportlineid=all&reportsublineid=all&country_group=TOT&countryid=AF|AL|DZ|AS|AO|AI|AG|AR|AM|AW|AU|AT|AZ|BS|BH|BD|BB|BY|BE|BZ|BJ|BM|BT|BO|BA|BW|BR|IO|VG|BN|BG|BF|BI|KH|CM|CA|CV|KY|CF|TD|CL|CN|CX|CC|CO|KM|CK|CR|CI|HR|CU|CY|CZ|CS|DK|DJ|DM|DO|CD|EC|EG|SV|GQ|ER|EE|ET|FK|FO|FJ|FI|FR|GF|PF|GA|GM|GE|DE|GH|GI|GR|GD|GP|GU|GT|GN|GW|GY|HT|HN|HU|IS|IN|ID|IR|IQ|IE|IL|IT|JM|JP|Jo|KZ|KE|KI|KW|KG|LA|LV|LB|LS|LR|LY|LI|LT|LX|MK|MG|MW|MY|MV|ML|MT|MH|MQ|MR|MU|YT|MX|FM|MD|MN|MS|MA|MZ|MM|NA|NR|NP|NL|AN|NC|NZ|NI|NE|NG|NU|NF|KP|MP|NO|OM|PK|PW|PS|PA|PG|PY|PE|PH|PN|PL|PT|PR|QA|CG|RE|RO|RU|RW|SH|KN|LC|PM|VC|WS|SM|ST|SA|SN|RS|SC|SL|SG|SK|SI|SB|SO|ZA|KR|ES|LK|SD|SR|SZ|SE|CH|SY|TW|TJ|TZ|TH|TL|TG|TK|TO|TT|TN|TR|TM|TC|TV|UG|UA|AE|GB|US|UY|VI|SU|UZ|VU|VE|VN|WF|YE|YU|ZM|ZW&debug=false&rnd=1516194929098&titeltext=huiasdhu"
destfile<-"extract_abs.xls"
download(url, destfile)

### OPEN FROM FILE (MODIFIED AND SAVED)
# Assign ISO3 codes????


