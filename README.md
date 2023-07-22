# infringed_bonds
## Introduction
I was inspired to conduct the following research by a graduate course taught by prof. Kirsten Wandschneider at the University of Vienna in the Summer Semester 2023. It has been considered a blockbuster among her students and served as an amazing survey into methods employed by financial and economic historians as well as macro economists. I am also indebted to Piotr Langier for our conversations about infringement measures.

The following working paper introduces the work I have done so far, skipping through most of theoretical grounding and instead jumping directly to the methodological issues I encountered so far. It is therefore limited to three sections discussing the data collection process, the empirical strategy and finally the problems and limitations I find the most challenging at the moment.

All data and code is available at my GitHub repository.

## Data
### Bonds
The data on the bond yields comes from the index of a number of Polish public finance instruments run by the Warsaw Stock Exchange - the TBSP Index (R). The data is unavailable in any downloadable form online and therefore I had to scrap it from the [TBSP website](https://www.bondspot.pl/tbsp_index_archiwum) (See TBSP_Scrapper.ipynb). The data now shows both the index value and the calculated daily change, reflecting the difference between 'open' and 'close'. The key limitation of that data is the lack of certain dates, when the index was not published or was published only partially.
### Infringement Measures
The calendar of announced infringement measures introduced by the European Commission against the member states is available at the Commission [website](https://ec.europa.eu/atwork/applying-eu-law/infringements-proceedings/infringement_decisions/screen/home?lang_code=en) as a large excel file presenting  the date, decision number and a brief case description. It would be also theoretically possible to determine whether the case is still significant, but it is impossible using the data I have at the moment to mark when it was resolved.
### Interest Rates
Quite surprisingly the interest data was less available than the previously discussed information. Nonetheless, after analysing the archival data from the National Bank of Poland I managed to get a list of rate changes.
### Robustness Checks
To conduct additional robustness checks I looked at the possible effect of infringement measures on WIG20 and WIG Banks, two leading indexes on the Warsaw Stock Exchange. The data comes from a website [investing.com](https://www.investing.com). In the case of WIG20, there were only small issues - two dates had missing TBSP entries, which was resolved by dropping these entries. WIG Banks has a similar minor issue, resolved in the same way. The dataset included one entry with a date on Sunday. I am unsure why there would by such an entry, and for integrity I dropped that data point too.

## Empirical Strategy and Further Development
### Event Study
### Regression Specification
$$
\begin{align}

change_{t} = \beta_{0}+\beta_{1}infringement_{t} + \beta_{2} \Delta rate_{t} +\beta_{3} w_{t-1} +\beta_{4} w_{t-2} +\beta_{5} w_{t-3} +\beta_{5} w_{t-4} +\beta_{6} w_{t-5} + \epsilon_{t}
\\
change_{t} = \beta_{0}+\beta_{1}rule \: of\:law_{t} + \beta_{2}financial \: marke ts _{t} + \beta_{3}budget_{t} +\beta_{4} \Delta rate_{t} +\beta_{5} w_{t-1} +\beta_{6} w_{t-2} +\beta_{7} w_{t -3} +\beta_{8} w_{t-4} +\beta_{9} w_{t-5} + \epsilon_{t}


\end{align}
$$

### Standard Errors
Standard Errors are correlated within dates, so the specification needs robust standard errors to work properly.
### Next Steps
## Limitations
