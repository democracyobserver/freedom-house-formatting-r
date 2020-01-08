# freedom-house-formatting-r

This poorly-named repository contains the code file that I use to reformat the country-year FIW data provided by Freedom House in Excel format for use in R. 

The data on country-year aggregate scores and statuses is provided by Freedom House at [https://freedomhouse.org/report-types/freedom-world](https://freedomhouse.org/report-types/freedom-world). Navigate to the "Data and Resources" heading and get the file named *Country and Territory Ratings and Statuses, 1973-xxxx (Excel)* where "*xxxx*" is the most recent year available. Or, simply download it from [here](https://freedomhouse.org/sites/default/files/Country_and_Territory_Ratings_and_Statuses_FIW1973-2019.xls)

The resulting data frame can be merged with other data using country-year identifiers; there are many methods to ensure matching, including using the `countrycode` package as I have in this code file.

### Codebook for resulting data

<table style="text-align:center"><tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left"></td><td>Variable</td><td>Label</td></tr>                                                                                      
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td style="text-align:left">1</td><td>iso3c</td><td>ISO character ID</td></tr>                       
<tr><td style="text-align:left">2</td><td>cown</td><td>COW numeric ID</td></tr>        
<tr><td style="text-align:left">3</td><td>country.name</td><td>Country name</td></tr>
<tr><td style="text-align:left">4</td><td>year</td><td>Year</td></tr>
<tr><td style="text-align:left">5</td><td>cl</td><td>Civil liberties score</td></tr>
<tr><td style="text-align:left">6</td><td>pr</td><td>Political rights score</td></tr>
<tr><td style="text-align:left">7</td><td>fh.score</td><td>Combined score (mean)</td></tr>
<tr><td style="text-align:left">8</td><td>status</td><td>Freedom status</td></tr>
<tr><td style="text-align:left">9</td><td>fh.score.rev</td><td>Combined score, reversed</td></tr>
<tr><td style="text-align:left">10</td><td>fh.score.rstd</td><td>Combined score, reversed and standardized</td></tr>
<tr><td colspan="3" style="border-bottom: 1px solid black"></td></tr><tr><td colspan="3" style="text-align:left">Dataframe with 9635 observations.</td></tr>
</table>
