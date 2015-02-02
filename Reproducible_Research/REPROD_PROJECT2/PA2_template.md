
<center> <h2>Examining National Storm Data - Economic and Health Consequences of Weather Events</h2> </center>
<center> By [James Lamb](http://www.linkedin.com/in/jameslamb1/)</center>
<center>-----------------------------------------------------------------------------------------------------------------------------------------------------</center>

###I. Synopsis

This is a brief (in content) but verbose (in code) project prepared in partial fulfillment of the requirements for the [Reproducible Research](https://class.coursera.org/repdata-010) course offered by Johns Hopkins University via Coursera, as part of the JHU Data Science Specialization. 

In this report, I sought to determine the health and economic impacts of storms using the US NOAA National Weather Service dataset on storms. I began by downloading the raw csv file and examining the contents. After that, I put a substantial amount of effort into cleaning the data and reducing the many entries for storm event type to the 48 unique values listed in the documentation. After that, I did some very basic aggregation and preliminary analysis. This crude analysis, which suffered from many weaknesses, suggested that tornadoes have caused the most economic and health damage, cumulatively, over the last 60 years or so. Hurricanes and tsunamis, though far less frequent, tended to be the most deadly and have the largest economic impacts on average.

The analysis suffered from many limitations, and its finding are weak at best. Please read the concluding remarks, and contact me if you have additional ideas for improvement.

###II. Data Processing

This analysis relies on storm data collected by the U.S. national Oceanic and Atmospheric Administration (NOAA) and distributed by [the instructor](https://twitter.com/rdpeng), and can be downloaded [here](https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2). There is also some supporting documentation available [here](https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf) and [here](https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2FNCDC%20Storm%20Events-FAQ%20Page.pdf). 

The dataset includes detailed information, from 1950 through 2011, on storm characteristics like location, timing, fatalities/injuries caused, and property damages. 

There are a total of 359,191 observations in the dataset. All missing data were coded as "NA" in the original dataset.


```r
## Define a function to download a bzip2-compressed csv from the internet, read it in to R                       
read.bzip2csv <- function(url, file, header = TRUE, sep = ",", stringsAsFactors = FALSE){
    
    ## check to see if the data have already been downloaded
    if(file.exists(file)==FALSE) {
    
        ## download the data
        download.file(url, destfile = file) #note that we use one arg, "file", for     destfile and later for the read in to R   
        }
    
    ## read the data into R
    data1 <<- read.csv(file = file, header = header, sep = sep, stringsAsFactors = stringsAsFactors, strip.white=TRUE)
   
    ## print output message to the console
    out_string <- "Data downloaded succesfully, read into R, and stored in object data1."
    out_string
}

## Read in the data for this project
read.bzip2csv(url= "http://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2", file = ".\\SStormdata.csv.bz2", sep = ",", header = TRUE, stringsAsFactors = FALSE)
```

```
## [1] "Data downloaded succesfully, read into R, and stored in object data1."
```

Next, I took some steps to clean the data. To begin, I looked at the unique values of ```EVTYPE``` to see how things could be condensed/combined.


```r
## Check unique values of EVTYPE
freqtable <- sort(table(as.factor(data1$EVTYPE))) 
freqtable
```

```
## 
##             HIGH SURF ADVISORY                  COASTAL FLOOD 
##                              1                              1 
##                    FLASH FLOOD                      LIGHTNING 
##                              1                              1 
##                TSTM WIND (G45)                     WATERSPOUT 
##                              1                              1 
##                           WIND                              ? 
##                              1                              1 
##                 ABNORMALLY WET                  APACHE COUNTY 
##                              1                              1 
##                       AVALANCE                   BEACH EROSIN 
##                              1                              1 
##                  Beach Erosion    BEACH EROSION/COASTAL FLOOD 
##                              1                              1 
##              BITTER WIND CHILL        BLIZZARD AND HEAVY SNOW 
##                              1                              1 
##               Blizzard Summary               BLIZZARD WEATHER 
##                              1                              1 
##         BLIZZARD/FREEZING RAIN             BLIZZARD/HIGH WIND 
##                              1                              1 
##          BLIZZARD/WINTER STORM                  BLOW-OUT TIDE 
##                              1                              1 
##                 BLOW-OUT TIDES BLOWING SNOW- EXTREME WIND CHI 
##                              1                              1 
## BLOWING SNOW/EXTREME WIND CHIL               BREAKUP FLOODING 
##                              1                              1 
##                    BRUSH FIRES      COASTAL  FLOODING/EROSION 
##                              1                              1 
##                COASTAL EROSION                   COASTALFLOOD 
##                              1                              1 
##                   COASTALSTORM               COLD AIR TORNADO 
##                              1                              1 
##                 COLD AND FROST                  COLD AND SNOW 
##                              1                              1 
##        COLD AND WET CONDITIONS                     COLD/WINDS 
##                              1                              1 
##                   COOL AND WET                     COOL SPELL 
##                              1                              1 
##                    DAM FAILURE                      DEEP HAIL 
##                              1                              1 
##                   DRIEST MONTH                  Drifting Snow 
##                              1                              1 
##                       DROWNING                DRY HOT WEATHER 
##                              1                              1 
##              DRY MICROBURST 50              DRY MICROBURST 53 
##                              1                              1 
##              DRY MICROBURST 61              DRY MICROBURST 84 
##                              1                              1 
##           DRY MIRCOBURST WINDS                    DRY PATTERN 
##                              1                              1 
##                        DRYNESS                     DUST DEVEL 
##                              1                              1 
##          DUST DEVIL WATERSPOUT          DUST STORM/HIGH WINDS 
##                              1                              1 
##                      DUSTSTORM                   EARLY FREEZE 
##                              1                              1 
##                    Early Frost                    EARLY FROST 
##                              1                              1 
##                     EARLY RAIN                      EXCESSIVE 
##                              1                              1 
##         EXCESSIVE HEAT/DROUGHT        EXCESSIVE PRECIPITATION 
##                              1                              1 
##              EXCESSIVE WETNESS                EXCESSIVELY DRY 
##                              1                              1 
##                  Extended Cold EXTREME WIND CHILL/BLOWING SNO 
##                              1                              1 
##            EXTREME WIND CHILLS                  EXTREMELY WET 
##                              1                              1 
##                    FIRST FROST         FLASH FLOOD LANDSLIDES 
##                              1                              1 
##              FLASH FLOOD WINDS                   FLASH FLOOD/ 
##                              1                              1 
##            FLASH FLOOD/ STREET         FLASH FLOOD/HEAVY RAIN 
##                              1                              1 
##          FLASH FLOOD/LANDSLIDE FLASH FLOODING/THUNDERSTORM WI 
##                              1                              1 
##                FLASH FLOOODING                          Flood 
##                              1                              1 
##              FLOOD FLOOD/FLASH                   FLOOD WATCH/ 
##                              1                              1 
##              Flood/Flash Flood              FLOOD/FLASH/FLOOD 
##                              1                              1 
##               FLOOD/FLASHFLOOD                FLOOD/RAIN/WIND 
##                              1                              1 
##              FLOOD/RIVER FLOOD              Flood/Strong Wind 
##                              1                              1 
##            FLOODING/HEAVY RAIN      FOG AND COLD TEMPERATURES 
##                              1                              1 
##                   FOREST FIRES               Freezing drizzle 
##                              1                              1 
##  FREEZING DRIZZLE AND FREEZING                   Freezing Fog 
##                              1                              1 
##         FREEZING RAIN AND SNOW        FREEZING RAIN SLEET AND 
##                              1                              1 
##  FREEZING RAIN SLEET AND LIGHT                 Freezing Spray 
##                              1                              1 
##                   Frost/Freeze                  FROST\\FREEZE 
##                              1                              1 
##                  FUNNEL CLOUD.              FUNNEL CLOUD/HAIL 
##                              1                              1 
##                        FUNNELS                GLAZE/ICE STORM 
##                              1                              1 
##                    GRASS FIRES                   GUSTNADO AND 
##                              1                              1 
##                GUSTY LAKE WIND                     Gusty Wind 
##                              1                              1 
##                GUSTY WIND/HAIL            GUSTY WIND/HVY RAIN 
##                              1                              1 
##                Gusty wind/rain                      HAIL 0.88 
##                              1                              1 
##                       HAIL 075                       HAIL 088 
##                              1                              1 
##                     HAIL 1.75)                       HAIL 125 
##                              1                              1 
##                       HAIL 200                       HAIL 225 
##                              1                              1 
##                       HAIL 450                        HAIL 88 
##                              1                              1 
##                     HAIL ALOFT                  HAIL FLOODING 
##                              1                              1 
##                     HAIL STORM                     Hail(0.75) 
##                              1                              1 
##                 HAIL/ICY ROADS                     HAILSTORMS 
##                              1                              1 
##                 HAZARDOUS SURF                   HEAT DROUGHT 
##                              1                              1 
##                      Heat Wave              HEAT WAVE DROUGHT 
##                              1                              1 
##                   HEAT/DROUGHT                      Heatburst 
##                              1                              1 
##            HEAVY PRECIPATATION            HEAVY PRECIPITATION 
##                              1                              1 
##           HEAVY RAIN AND FLOOD             HEAVY RAIN EFFECTS 
##                              1                              1 
##           Heavy Rain/High Surf           HEAVY RAIN/LIGHTNING 
##                              1                              1 
##     HEAVY RAIN/MUDSLIDES/FLOOD  HEAVY RAIN/SMALL STREAM URBAN 
##                              1                              1 
##                HEAVY RAIN/SNOW         HEAVY RAIN/URBAN FLOOD 
##                              1                              1 
## HEAVY RAIN; URBAN FLOOD WINDS;                  HEAVY SHOWERS 
##                              1                              1 
##     HEAVY SNOW   FREEZING RAIN               HEAVY SNOW & ICE 
##                              1                              1 
##                 HEAVY SNOW AND    HEAVY SNOW AND STRONG WINDS 
##                              1                              1 
##     HEAVY SNOW ANDBLOWING SNOW              Heavy snow shower 
##                              1                              1 
##  HEAVY SNOW/BLIZZARD/AVALANCHE        HEAVY SNOW/BLOWING SNOW 
##                              1                              1 
##                HEAVY SNOW/HIGH           HEAVY SNOW/HIGH WIND 
##                              1                              1 
##          HEAVY SNOW/HIGH WINDS  HEAVY SNOW/HIGH WINDS & FLOOD 
##                              1                              1 
## HEAVY SNOW/HIGH WINDS/FREEZING               HEAVY SNOW/SLEET 
##                              1                              1 
##                HEAVY SNOW/WIND        HEAVY SNOW/WINTER STORM 
##                              1                              1 
##                 HEAVY SNOWPACK            Heavy surf and wind 
##                              1                              1 
##    HEAVY SURF COASTAL FLOODING                   HEAVY SWELLS 
##                              1                              1 
##                 HEAVY WET SNOW                           HIGH 
##                              1                              1 
##                   HIGH  SWELLS                    HIGH  WINDS 
##                              1                              1 
##           HIGH SURF ADVISORIES                   HIGH WIND 48 
##                              1                              1 
##                   HIGH WIND 63                   HIGH WIND 70 
##                              1                              1 
##       HIGH WIND AND HEAVY SNOW             HIGH WIND AND SEAS 
##                              1                              1 
##            HIGH WIND/ BLIZZARD HIGH WIND/BLIZZARD/FREEZING RA 
##                              1                              1 
##       HIGH WIND/LOW WIND CHILL                 HIGH WIND/SEAS 
##                              1                              1 
##           HIGH WIND/WIND CHILL  HIGH WIND/WIND CHILL/BLIZZARD 
##                              1                              1 
##                  HIGH WINDS 55                  HIGH WINDS 57 
##                              1                              1 
##                  HIGH WINDS 58                  HIGH WINDS 67 
##                              1                              1 
##                  HIGH WINDS 73                  HIGH WINDS 76 
##                              1                              1 
##                  HIGH WINDS 82      HIGH WINDS AND WIND CHILL 
##                              1                              1 
##          HIGH WINDS DUST STORM         HIGH WINDS HEAVY RAINS 
##                              1                              1 
##                    HIGH WINDS/       HIGH WINDS/COASTAL FLOOD 
##                              1                              1 
##            HIGH WINDS/FLOODING          HIGH WINDS/HEAVY RAIN 
##                              1                              1 
##               HIGHWAY FLOODING                    HOT PATTERN 
##                              1                              1 
##                    HOT WEATHER                HOT/DRY PATTERN 
##                              1                              1 
##                HURRICANE EMILY               HURRICANE GORDON 
##                              1                              1 
##      HURRICANE OPAL/HIGH WINDS          HYPERTHERMIA/EXPOSURE 
##                              1                              1 
##                    HYPOTHERMIA                   ICE AND SNOW 
##                              1                              1 
##           Ice jam flood (minor                    ICE ON ROAD 
##                              1                              1 
##                    ICE PELLETS                      ICE ROADS 
##                              1                              1 
##             ICE STORM AND SNOW          ICE STORM/FLASH FLOOD 
##                              1                              1 
##               ICE/STRONG WINDS              Icestorm/Blizzard 
##                              1                              1 
##                   LACK OF SNOW                     LAKE FLOOD 
##                              1                              1 
##          LANDSLIDE/URBAN FLOOD                      Landslump 
##                              1                              1 
##                      LANDSLUMP               LARGE WALL CLOUD 
##                              1                              1 
##           Late-season Snowfall                    LATE FREEZE 
##                              1                              1 
##               LATE SEASON HAIL               LATE SEASON SNOW 
##                              1                              1 
##                     Light snow     LIGHT SNOW/FREEZING PRECIP 
##                              1                              1 
##                 Light Snowfall             LIGHTNING  WAUSEON 
##                              1                              1 
##       LIGHTNING AND HEAVY RAIN LIGHTNING AND THUNDERSTORM WIN 
##                              1                              1 
##            LIGHTNING AND WINDS               LIGHTNING DAMAGE 
##                              1                              1 
##                 LIGHTNING FIRE               LIGHTNING INJURY 
##                              1                              1 
##   LIGHTNING THUNDERSTORM WINDS  LIGHTNING THUNDERSTORM WINDSS 
##                              1                              1 
##                     LIGHTNING.           LIGHTNING/HEAVY RAIN 
##                              1                              1 
##                      LIGNTNING              LOCAL FLASH FLOOD 
##                              1                              1 
##                    LOCAL FLOOD             LOCALLY HEAVY RAIN 
##                              1                              1 
##         LOW TEMPERATURE RECORD                 LOW WIND CHILL 
##                              1                              1 
##                Marine Accident            Metro Storm, May 26 
##                              1                              1 
##           Mild and Dry Pattern                   MILD PATTERN 
##                              1                              1 
##               MILD/DRY PATTERN                    MINOR FLOOD 
##                              1                              1 
##                 Minor Flooding                  MODERATE SNOW 
##                              1                              1 
##               Monthly Snowfall               MONTHLY SNOWFALL 
##                              1                              1 
##                 Mountain Snows                     MUD SLIDES 
##                              1                              1 
##      MUD SLIDES URBAN FLOODING                 MUD/ROCK SLIDE 
##                              1                              1 
##             MUDSLIDE/LANDSLIDE               NEAR RECORD SNOW 
##                              1                              1 
##              No Severe Weather         NON-SEVERE WIND DAMAGE 
##                              1                              1 
##                  NON-TSTM WIND                NORTHERN LIGHTS 
##                              1                              1 
##                     PATCHY ICE              PROLONG COLD/SNOW 
##                              1                              1 
##                   RAIN (HEAVY)                  RAIN AND WIND 
##                              1                              1 
##                    Rain Damage                      RAIN/WIND 
##                              1                              1 
##                      RAINSTORM           RAPIDLY RISING WATER 
##                              1                              1 
##                   RECORD  COLD      RECORD COLD AND HIGH WIND 
##                              1                              1 
##               Record dry month                    Record Heat 
##                              1                              1 
##               RECORD HEAT WAVE       RECORD HIGH TEMPERATURES 
##                              1                              1 
##                Record May Snow           RECORD PRECIPITATION 
##                              1                              1 
##               RECORD SNOW/COLD                    RECORD WARM 
##                              1                              1 
##             RECORD WARM TEMPS.      RECORD/EXCESSIVE RAINFALL 
##                              1                              1 
##        RIP CURRENTS HEAVY SURF                     ROGUE WAVE 
##                              1                              1 
##              Seasonal Snowfall                    SEVERE COLD 
##                              1                              1 
##              SEVERE TURBULENCE          SLEET & FREEZING RAIN 
##                              1                              1 
##                SLEET/ICE STORM                SLEET/RAIN/SNOW 
##                              1                              1 
##                     Small Hail                   SMALL STREAM 
##                              1                              1 
##               SMALL STREAM AND SMALL STREAM AND URBAN FLOODIN 
##                              1                              1 
##       SMALL STREAM URBAN FLOOD    SNOW- HIGH WIND- WIND CHILL 
##                              1                              1 
##              Snow Accumulation              SNOW ACCUMULATION 
##                              1                              1 
##                  SNOW ADVISORY                   Snow and Ice 
##                              1                              1 
##             SNOW AND ICE STORM                 Snow and sleet 
##                              1                              1 
##                  SNOW AND WIND                     SNOW SLEET 
##                              1                              1 
##                   Snow squalls              SNOW/ BITTER COLD 
##                              1                              1 
##                      SNOW/ ICE                SNOW/HEAVY SNOW 
##                              1                              1 
##                      SNOW/RAIN                SNOW/RAIN/SLEET 
##                              1                              1 
##                SNOW/SLEET/RAIN                     SNOW\\COLD 
##                              1                              1 
##                SNOWFALL RECORD                      SNOWSTORM 
##                              1                              1 
##                      SOUTHEAST              STORM FORCE WINDS 
##                              1                              1 
##                STREAM FLOODING                   Strong winds 
##                              1                              1 
##              Summary August 17             Summary August 2-3 
##                              1                              1 
##              Summary August 21              Summary August 28 
##                              1                              1 
##               Summary August 4               Summary August 7 
##                              1                              1 
##               Summary August 9                 Summary Jan 17 
##                              1                              1 
##             Summary July 23-24             Summary June 18-19 
##                              1                              1 
##               Summary June 5-6                 Summary June 6 
##                              1                              1 
##            Summary of April 13            Summary of April 27 
##                              1                              1 
##           Summary of April 3rd            Summary of August 1 
##                              1                              1 
##             Summary of July 11              Summary of July 2 
##                              1                              1 
##             Summary of July 22             Summary of July 26 
##                              1                              1 
##             Summary of July 29              Summary of July 3 
##                              1                              1 
##             Summary of June 10             Summary of June 11 
##                              1                              1 
##             Summary of June 12             Summary of June 15 
##                              1                              1 
##             Summary of June 16             Summary of June 18 
##                              1                              1 
##             Summary of June 23             Summary of June 24 
##                              1                              1 
##             Summary of June 30              Summary of June 4 
##                              1                              1 
##              Summary of June 6            Summary of March 14 
##                              1                              1 
##            Summary of March 24         SUMMARY OF MARCH 24-25 
##                              1                              1 
##            SUMMARY OF MARCH 27            SUMMARY OF MARCH 29 
##                              1                              1 
##              Summary of May 10              Summary of May 13 
##                              1                              1 
##              Summary of May 14              Summary of May 22 
##                              1                              1 
##           Summary of May 22 am           Summary of May 22 pm 
##                              1                              1 
##           Summary of May 26 am           Summary of May 26 pm 
##                              1                              1 
##           Summary of May 31 am           Summary of May 31 pm 
##                              1                              1 
##            Summary of May 9-10            Summary Sept. 25-26 
##                              1                              1 
##           Summary September 20            Summary September 3 
##                              1                              1 
##            Summary September 4              Summary: Nov. 6-7 
##                              1                              1 
##            Summary: Oct. 20-21            Summary: October 31 
##                              1                              1 
##              Summary: Sept. 18            THUNDERESTORM WINDS 
##                              1                              1 
##                    THUNDERSNOW             Thundersnow shower 
##                              1                              1 
##         THUNDERSTORM DAMAGE TO              THUNDERSTORM HAIL 
##                              1                              1 
##            THUNDERSTORM W INDS              Thunderstorm Wind 
##                              1                              1 
##        THUNDERSTORM WIND (G40)           THUNDERSTORM WIND 52 
##                              1                              1 
##           THUNDERSTORM WIND 56           THUNDERSTORM WIND 59 
##                              1                              1 
##       THUNDERSTORM WIND 59 MPH      THUNDERSTORM WIND 59 MPH. 
##                              1                              1 
##       THUNDERSTORM WIND 65 MPH        THUNDERSTORM WIND 65MPH 
##                              1                              1 
##           THUNDERSTORM WIND 69       THUNDERSTORM WIND 98 MPH 
##                              1                              1 
##          THUNDERSTORM WIND G51          THUNDERSTORM WIND G55 
##                              1                              1 
##          THUNDERSTORM WIND G61        THUNDERSTORM WIND TREES 
##                              1                              1 
##             THUNDERSTORM WIND.        THUNDERSTORM WIND/ TREE 
##                              1                              1 
##       THUNDERSTORM WIND/AWNING         THUNDERSTORM WIND/HAIL 
##                              1                              1 
##    THUNDERSTORM WIND/LIGHTNING THUNDERSTORM WINDS      LE CEN 
##                              1                              1 
##          THUNDERSTORM WINDS 13           THUNDERSTORM WINDS 2 
##                              1                              1 
##          THUNDERSTORM WINDS 50          THUNDERSTORM WINDS 52 
##                              1                              1 
##          THUNDERSTORM WINDS 53          THUNDERSTORM WINDS 60 
##                              1                              1 
##          THUNDERSTORM WINDS 61          THUNDERSTORM WINDS 62 
##                              1                              1 
##      THUNDERSTORM WINDS 63 MPH         THUNDERSTORM WINDS G60 
##                              1                              1 
##  THUNDERSTORM WINDS HEAVY RAIN THUNDERSTORM WINDS SMALL STREA 
##                              1                              1 
## THUNDERSTORM WINDS URBAN FLOOD       THUNDERSTORM WINDS/ HAIL 
##                              1                              1 
## THUNDERSTORM WINDS/FLASH FLOOD    THUNDERSTORM WINDS/FLOODING 
##                              1                              1 
## THUNDERSTORM WINDS/FUNNEL CLOU  THUNDERSTORM WINDS/HEAVY RAIN 
##                              1                              1 
##           THUNDERSTORM WINDS53         THUNDERSTORM WINDSHAIL 
##                              1                              1 
##              THUNDERSTORM WINS                  THUNDERSTORMW 
##                              1                              1 
##               THUNDERSTORMW 50              THUNDERSTORMWINDS 
##                              1                              1 
##              THUNDERSTROM WIND              THUNDERTSORM WIND 
##                              1                              1 
##              THUNERSTORM WINDS                    TIDAL FLOOD 
##                              1                              1 
##                 TORNADO DEBRIS             TORNADO/WATERSPOUT 
##                              1                              1 
##     TORNADOES, TSTM WIND, HAIL                       TORNADOS 
##                              1                              1 
##                        TORNDAO                TORRENTIAL RAIN 
##                              1                              1 
##            Torrential Rainfall         TROPICAL STORM ALBERTO 
##                              1                              1 
##          TROPICAL STORM GORDON                           TSTM 
##                              1                              1 
##               TSTM WIND  (G45)                 TSTM WIND (41) 
##                              1                              1 
##                TSTM WIND (G35)                   TSTM WIND 40 
##                              1                              1 
##                   TSTM WIND 45                   TSTM WIND 50 
##                              1                              1 
##                  TSTM WIND 65)        TSTM WIND AND LIGHTNING 
##                              1                              1 
##               TSTM WIND DAMAGE                  TSTM WIND G45 
##                              1                              1 
##                  TSTM WIND G58                       TSTM WND 
##                              1                              1 
##                          TSTMW               TUNDERSTORM WIND 
##                              1                              1 
##              Unseasonable Cold        UNSEASONABLY WARM & WET 
##                              1                              1 
##            UNUSUALLY LATE SNOW                    Urban flood 
##                              1                              1 
##                    Urban Flood          URBAN FLOOD LANDSLIDE 
##                              1                              1 
##                 Urban Flooding                    URBAN SMALL 
##                              1                              1 
##           URBAN/SMALL FLOODING          URBAN/SMALL STRM FLDG 
##                              1                              1 
##          URBAN/SML STREAM FLDG                      VERY WARM 
##                              1                              1 
##                            VOG                   Volcanic Ash 
##                              1                              1 
##             Volcanic Ash Plume        WALL CLOUD/FUNNEL CLOUD 
##                              1                              1 
##            WARM DRY CONDITIONS                   WARM WEATHER 
##                              1                              1 
##                    WATER SPOUT        WATERSPOUT FUNNEL CLOUD 
##                              1                              1 
##             WATERSPOUT TORNADO                    WATERSPOUT/ 
##                              1                              1 
##                    WAYTERSPOUT                  wet micoburst 
##                              1                              1 
##                       WET SNOW                    WET WEATHER 
##                              1                              1 
##                      WHIRLWIND              WILD/FOREST FIRES 
##                              1                              1 
##                  WIND AND WAVE           WIND CHILL/HIGH WIND 
##                              1                              1 
##                     WIND STORM                      WIND/HAIL 
##                              1                              1 
##        WINTER STORM HIGH WINDS         WINTER STORM/HIGH WIND 
##                              1                              1 
##        WINTER STORM/HIGH WINDS                     Wintry Mix 
##                              1                              1 
##                            WND                 ABNORMALLY DRY 
##                              1                              2 
##                    BEACH FLOOD     BELOW NORMAL PRECIPITATION 
##                              2                              2 
## BLIZZARD AND EXTREME WIND CHIL            BLIZZARD/HEAVY SNOW 
##                              2                              2 
##                   blowing snow BLOWING SNOW & EXTREME WIND CH 
##                              2                              2 
##               coastal flooding                  Coastal Storm 
##                              2                              2 
##                  COASTAL SURGE            COASTAL/TIDAL FLOOD 
##                              2                              2 
##               COLD AIR FUNNELS               Cold Temperature 
##                              2                              2 
##          CSTL FLOODING/EROSION                Damaging Freeze 
##                              2                              2 
##                      DOWNBURST                DOWNBURST WINDS 
##                              2                              2 
##              DRY MICROBURST 58                 Early snowfall 
##                              2                              2 
##             Erosion/Cstl Flood                 Excessive Cold 
##                              2                              2 
##                   Extreme Cold               FALLING SNOW/ICE 
##                              2                              2 
##       FLASH FLOOD - HEAVY RAIN             FLASH FLOOD/ FLOOD 
##                              2                              2 
##             FLOOD & HEAVY RAIN                    FLOOD/FLASH 
##                              2                              2 
##           FLOOD/FLASH FLOODING                         Freeze 
##                              2                              2 
##                      GLAZE ICE                  gradient wind 
##                              2                              2 
##                GROUND BLIZZARD                    Gusty winds 
##                              2                              2 
##                       HAIL 150                        HAIL 80 
##                              2                              2 
##                    HAIL DAMAGE                     HAIL/WINDS 
##                              2                              2 
##                     HEAT WAVES            Heavy Precipitation 
##                              2                              2 
##            HEAVY RAIN/FLOODING      HEAVY RAIN/SEVERE WEATHER 
##                              2                              2 
##                     HEAVY SEAS                   HEAVY SHOWER 
##                              2                              2 
##      HEAVY SNOW AND HIGH WINDS             HEAVY SNOW AND ICE 
##                              2                              2 
##       HEAVY SNOW AND ICE STORM       HEAVY SNOW/FREEZING RAIN 
##                              2                              2 
##           HEAVY SNOW/ICE STORM             HEAVY SNOW/SQUALLS 
##                              2                              2 
##                     HIGH TIDES                      High Wind 
##                              2                              2 
##                HIGH WIND (G40)       HIGH WIND AND HIGH TIDES 
##                              2                              2 
##               HIGH WIND DAMAGE                  HIGH WINDS 63 
##                              2                              2 
##                  HIGH WINDS 66                  HIGH WINDS 80 
##                              2                              2 
##                    Hot and Dry                      HOT SPELL 
##                              2                              2 
##              Hurricane Edouard                HURRICANE FELIX 
##                              2                              2 
##                       HVY RAIN                      ICE FLOES 
##                              2                              2 
##                        Ice Fog                       Ice/Snow 
##                              2                              2 
##               Lake Effect Snow                      LANDSPOUT 
##                              2                              2 
##           Late Season Snowfall                      LATE SNOW 
##                              2                              2 
##           LIGHT SNOW AND SLEET                  MARINE MISHAP 
##                              2                              2 
##               Monthly Rainfall                  NON TSTM WIND 
##                              2                              2 
##                           NONE              RECORD COLD/FROST 
##                              2                              2 
##                 RECORD DRYNESS                    Record High 
##                              2                              2 
##            RECORD LOW RAINFALL            Record Temperatures 
##                              2                              2 
##              RED FLAG CRITERIA               RED FLAG FIRE WX 
##                              2                              2 
##              REMNANTS OF FLOYD        RIP CURRENTS/HEAVY SURF 
##                              2                              2 
##         RIVER AND STREAM FLOOD                     ROCK SLIDE 
##                              2                              2 
##                    RURAL FLOOD                   Saharan Dust 
##                              2                              2 
##                   SAHARAN DUST            SLEET/FREEZING RAIN 
##                              2                              2 
##                     SLEET/SNOW   SMALL STREAM AND URBAN FLOOD 
##                              2                              2 
##                 Sml Stream Fld                  SNOW AND COLD 
##                              2                              2 
##            SNOW AND HEAVY SNOW                      SNOW/COLD 
##                              2                              2 
##                SNOW/HIGH WINDS               STRONG WIND GUST 
##                              2                              2 
##              Summary August 10              Summary August 11 
##                              2                              2 
##            Summary of April 12            Summary of April 21 
##                              2                              2 
##             Summary of June 13              Summary of June 3 
##                              2                              2 
##            Summary of March 23           Summary September 23 
##                              2                              2 
##               Summary: Nov. 16              THUDERSTORM WINDS 
##                              2                              2 
##            THUNDEERSTORM WINDS            THUNDERSTORM DAMAGE 
##                              2                              2 
##           THUNDERSTORM WIND 50          THUNDERSTORM WIND G52 
##                              2                              2 
##          THUNDERSTORM WIND G60         THUNDERSTORM WINDS AND 
##                              2                              2 
## THUNDERSTORM WINDS FUNNEL CLOU           THUNDERSTORM WINDS G 
##                              2                              2 
##      THUNDERSTORM WINDS/ FLOOD             THUNDERSTROM WINDS 
##                              2                              2 
##              THUNDESTORM WINDS                     TORNADO F3 
##                              2                              2 
##                      TORNADOES            TROPICAL STORM DEAN 
##                              2                              2 
##                      Tstm Wind                   TSTM WIND 51 
##                              2                              2 
##        UNSEASONABLY COOL & WET         UNSEASONABLY WARM YEAR 
##                              2                              2 
##          UNSEASONABLY WARM/WET            UNSEASONAL LOW TEMP 
##                              2                              2 
##                UNSEASONAL RAIN          UNUSUAL/RECORD WARMTH 
##                              2                              2 
##                URBAN AND SMALL       URBAN SMALL STREAM FLOOD 
##                              2                              2 
##                    URBAN/SMALL      URBAN/SMALL STREAM  FLOOD 
##                              2                              2 
##                       VERY DRY              VOLCANIC ERUPTION 
##                              2                              2 
##                  WAKE LOW WIND             WATERSPOUT-TORNADO 
##                              2                              2 
##            WATERSPOUT/ TORNADO                      Whirlwind 
##                              2                              2 
##                    WINTERY MIX                  BEACH EROSION 
##                              2                              3 
## BITTER WIND CHILL TEMPERATURES                      Black Ice 
##                              3                              3 
##                   Blowing Snow                     BRUSH FIRE 
##                              3                              3 
##                      COLD WAVE                     EARLY SNOW 
##                              3                              3 
##                    FLOOD FLASH                         FLOODS 
##                              3                              3 
##               Freezing Drizzle                  Freezing rain 
##                              3                              3 
##                  GRADIENT WIND        GUSTY THUNDERSTORM WIND 
##                              3                              3 
##                       HAIL 275                      HAIL/WIND 
##                              3                              3 
##                      HAILSTORM                     Heavy rain 
##                              3                              3 
##                 HEAVY RAINFALL            HEAVY SNOW/BLIZZARD 
##                              3                              3 
##                     Heavy Surf        HIGH TEMPERATURE RECORD 
##                              3                              3 
##                     HIGH WAVES           HIGH WIND/HEAVY SNOW 
##                              3                              3 
##                HIGH WINDS/SNOW     HURRICANE-GENERATED SWELLS 
##                              3                              3 
##           Hypothermia/Exposure           HYPOTHERMIA/EXPOSURE 
##                              3                              3 
##                       ICE/SNOW            Light Snow/Flurries 
##                              3                              3 
##                       LIGHTING                    MAJOR FLOOD 
##                              3                              3 
##                 MINOR FLOODING            Mixed Precipitation 
##                              3                              3 
##           NORMAL PRECIPITATION               PATCHY DENSE FOG 
##                              3                              3 
##                    Record Cold        RECORD HIGH TEMPERATURE 
##                              3                              3 
##            RECORD TEMPERATURES             Record Winter Snow 
##                              3                              3 
##          RECORD/EXCESSIVE HEAT                     ROUGH SEAS 
##                              3                              3 
##                   STREET FLOOD                STREET FLOODING 
##                              3                              3 
##                    Strong Wind            THUNDERSTORM WINDS. 
##                              3                              3 
##            THUNDERSTORMW WINDS              THUNDERTORM WINDS 
##                              3                              3 
##                     TORNADO F2           TROPICAL STORM JERRY 
##                              3                              3 
##                TSTM HEAVY RAIN                   TSTM WIND 55 
##                              3                              3 
##         URBAN AND SMALL STREAM   URBAN AND SMALL STREAM FLOOD 
##                              3                              3 
##                   URBAN FLOODS          URBAN/STREET FLOODING 
##                              3                              3 
##               VOLCANIC ASHFALL                     WIND GUSTS 
##                              3                              3 
##                     WINTER MIX                  WINTER STORMS 
##                              3                              3 
##                     Wintry mix                      TSTM WIND 
##                              3                              4 
##                ABNORMAL WARMTH           ACCUMULATED SNOWFALL 
##                              4                              4 
##                   BLOWING DUST                COLD AIR FUNNEL 
##                              4                              4 
##              COLD TEMPERATURES                   COLD WEATHER 
##                              4                              4 
##                      DAM BREAK                      DRY SPELL 
##                              4                              4 
##                    DRY WEATHER             EXCESSIVE RAINFALL 
##                              4                              4 
##            EXTREME/RECORD COLD             FREEZING RAIN/SNOW 
##                              4                              4 
##                          Frost                  Gradient wind 
##                              4                              4 
##                      HAIL 1.75            Heavy Rain and Wind 
##                              4                              4 
##                HEAVY RAIN/WIND             HIGH SURF ADVISORY 
##                              4                              4 
##                        ICE JAM                      Icy Roads 
##                              4                              4 
##                     Microburst            MONTHLY TEMPERATURE 
##                              4                              4 
##                      MUDSLIDES                          Other 
##                              4                              4 
##                 PROLONG WARMTH                 PROLONGED RAIN 
##                              4                              4 
##                     RECORD LOW                     ROUGH SURF 
##                              4                              4 
##          SMALL STREAM FLOODING                 SNOW AND SLEET 
##                              4                              4 
##                   Snow Squalls       THUNDERSTORM WIND 60 MPH 
##                              4                              4 
##          THUNDERSTORM WIND G50       THUNDERSTORM WIND/ TREES 
##                              4                              4 
##                  THUNDERSTORMS                     TORNADO F1 
##                              4                              4 
##                 UNUSUALLY WARM    URBAN/SMALL STREAM FLOODING 
##                              4                              4 
##                      Wet Month                       Wet Year 
##                              4                              4 
##                     WILD FIRES                    Wind Damage 
##                              4                              4 
##       COASTAL FLOODING/EROSION           DRY MICROBURST WINDS 
##                              5                              5 
##                 EARLY SNOWFALL                 EXCESSIVE RAIN 
##                              5                              5 
##      FLASH FLOOD FROM ICE JAMS                   Funnel Cloud 
##                              5                              5 
##       GUSTY THUNDERSTORM WINDS                 HEAVY SNOW/ICE 
##                              5                              5 
##                    HIGH SWELLS                HIGH WINDS/COLD 
##                              5                              5 
##               ICE JAM FLOODING                     MICROBURST 
##                              5                              5 
##               MICROBURST WINDS                      Mudslides 
##                              5                              5 
##                   Prolong Cold                      RAIN/SNOW 
##                              5                              5 
##                    RECORD COOL                    RECORD HIGH 
##                              5                              5 
##             RECORD TEMPERATURE                 River Flooding 
##                              5                              5 
##            ROTATING WALL CLOUD      SEVERE THUNDERSTORM WINDS 
##                              5                              5 
##                     small hail       SMALL STREAM/URBAN FLOOD 
##                              5                              5 
##              SNOWMELT FLOODING                 Tidal Flooding 
##                              5                              5 
##                   TSTM WIND 52                     WALL CLOUD 
##                              5                              5 
##            AGRICULTURAL FREEZE                  Coastal Flood 
##                              6                              6 
##                 Cold and Frost   COLD WIND CHILL TEMPERATURES 
##                              6                              6 
##                DAMAGING FREEZE                 DRY CONDITIONS 
##                              6                              6 
##             EXTREME WIND CHILL               FLOOD/RAIN/WINDS 
##                              6                              6 
##        FREEZING RAIN AND SLEET                       GUSTNADO 
##                              6                              6 
##                      HAIL 1.00                     HIGH WATER 
##                              6                              6 
##             HIGH WIND/BLIZZARD                RECORD SNOWFALL 
##                              6                              6 
##                   SNOW SHOWERS             SNOW/FREEZING RAIN 
##                              6                              6 
##       SNOW/SLEET/FREEZING RAIN             THUNDERSTORMS WIND 
##                              6                              6 
##                     TSTM WINDS URBAN AND SMALL STREAM FLOODIN 
##                              6                              6 
##                 WET MICROBURST                           Wind 
##                              6                              6 
##             WINTER WEATHER MIX                  Freezing Rain 
##                              6                              7 
##                    HARD FREEZE                 HURRICANE ERIN 
##                              7                              7 
##                LOW TEMPERATURE                      MUD SLIDE 
##                              7                              7 
##                NON SEVERE HAIL             SMALL STREAM FLOOD 
##                              7                              7 
##                   SNOW DROUGHT              SNOW/BLOWING SNOW 
##                              7                              7 
##                       SNOW/ICE                   Strong Winds 
##                              7                              7 
##            THUNDERSTORM  WINDS   THUNDERSTORM WINDS LIGHTNING 
##                              7                              7 
##                  COASTAL STORM                     Dust Devil 
##                              8                              8 
##           FLASH FLOODING/FLOOD                 GRADIENT WINDS 
##                              8                              8 
##                      HEAVY MIX                      HIGH SEAS 
##                              8                              8 
##                     LANDSLIDES                       Mudslide 
##                              8                              8 
##                    RECORD SNOW                  Record Warmth 
##                              8                              8 
##                 UNUSUALLY COLD             URBAN/SMALL STREAM 
##                              8                              8 
##             WATERSPOUT/TORNADO                      WILDFIRES 
##                              8                              8 
##                            DRY                     FIRST SNOW 
##                              9                              9 
##            FREEZING RAIN/SLEET           HEAVY RAINS/FLOODING 
##                              9                              9 
##                      High Surf                 HURRICANE OPAL 
##                              9                              9 
##                       MUDSLIDE                           Cold 
##                              9                             10 
##                    DENSE SMOKE                    Gusty Winds 
##                             10                             10 
##                   MIXED PRECIP                     SNOW/SLEET 
##                             10                             10 
##                TSTM WIND (G40)               UNSEASONABLY HOT 
##                             10                             10 
##                 UNUSUAL WARMTH                    WATERSPOUT- 
##                             10                             10 
##                          Glaze               MONTHLY RAINFALL 
##                             11                             11 
##             Record temperature                          SMOKE 
##                             11                             11 
##             SNOW FREEZING RAIN                        TYPHOON 
##                             11                             11 
##                   BLOWING SNOW                    SLEET STORM 
##                             12                             12 
##              UNSEASONABLY COOL                  WIND ADVISORY 
##                             12                             12 
##         DROUGHT/EXCESSIVE HEAT                       HAIL 100 
##                             13                             13 
##                       HAIL 175            SEVERE THUNDERSTORM 
##                             13                             13 
##      UNSEASONABLY WARM AND DRY                      BLACK ICE 
##                             13                             14 
##                RECORD RAINFALL            THUNDERSTORMS WINDS 
##                             14                             14 
##             HEAVY SNOW-SQUALLS                     Heavy Rain 
##                             15                             16 
##                           RAIN                   PROLONG COLD 
##                             16                             17 
##                   SNOW SQUALLS                 SNOW/ICE STORM 
##                             17                             17 
##                      HAIL 0.75                     WIND CHILL 
##                             18                             18 
## EXTREME WINDCHILL TEMPERATURES                    SNOW SQUALL 
##                             19                             19 
##                     TORNADO F0               UNSEASONABLY WET 
##                             19                             19 
##                 Winter Weather               FREEZING DRIZZLE 
##                             19                             20 
##                 TIDAL FLOODING                        TSUNAMI 
##                             20                             20 
##               LAKE EFFECT SNOW                     Light Snow 
##                             21                             21 
##                         SEICHE                   EXTREME HEAT 
##                             21                             22 
##              FLASH FLOOD/FLOOD                   VOLCANIC ASH 
##                             22                             22 
##                     GUSTY WIND                LAKESHORE FLOOD 
##                             23                             23 
##            LIGHT FREEZING RAIN           SEVERE THUNDERSTORMS 
##                             23                             23 
##              UNSEASONABLY COLD                 RIVER FLOODING 
##                             23                             24 
##        THUNDERSTORM WINDS/HAIL                 EXCESSIVE SNOW 
##                             24                             25 
##                HEAVY LAKE SNOW                    HEAVY RAINS 
##                             25                             26 
##                    WIND DAMAGE                      ICY ROADS 
##                             27                             28 
##                        HAIL 75                           Snow 
##                             29                             30 
##       URBAN/SMALL STREAM FLOOD                   FLASH FLOODS 
##                             30                             32 
##                          GLAZE             HEAVY SNOW SQUALLS 
##                             32                             32 
##                   SNOW AND ICE            MIXED PRECIPITATION 
##                             33                             34 
##          MONTHLY PRECIPITATION                          WINDS 
##                             36                             36 
##                    WATERSPOUTS               Coastal Flooding 
##                             37                             38 
##                TSTM WIND (G45)             Temperature record 
##                             39                             43 
##                   FREEZING FOG                   THUNDERSTORM 
##                             45                             45 
##                         FUNNEL                     SMALL HAIL 
##                             46                             47 
##             MARINE STRONG WIND                          OTHER 
##                             48                             48 
##            THUNDERSTORM WINDSS                          FROST 
##                             51                             53 
##                    GUSTY WINDS               UNSEASONABLY DRY 
##                             53                             56 
##                          SLEET            TROPICAL DEPRESSION 
##                             59                             60 
##                            ICE        THUNDERSTORM WINDS HAIL 
##                             61                             61 
##                    RECORD COLD                           COLD 
##                             64                             72 
##                         FREEZE                      HEAT WAVE 
##                             74                             74 
##                    RECORD HEAT                     HEAVY SURF 
##                             81                             84 
##                  FUNNEL CLOUDS              HURRICANE/TYPHOON 
##                             87                             88 
##                     WINTRY MIX                 URBAN FLOODING 
##                             90                             98 
##              MODERATE SNOWFALL         ASTRONOMICAL HIGH TIDE 
##                            101                            103 
##                       FLOODING              UNSEASONABLY WARM 
##                            120                            126 
##               MARINE HIGH WIND                     DUST DEVIL 
##                            135                            141 
##               COASTAL FLOODING                  RECORD WARMTH 
##                            143                            146 
##               STORM SURGE/TIDE                     LIGHT SNOW 
##                            148                            154 
##                    RIVER FLOOD          ASTRONOMICAL LOW TIDE 
##                            173                            174 
##                      HURRICANE                 DRY MICROBURST 
##                            174                            186 
##                   STRONG WINDS              EXTREME WINDCHILL 
##                            196                            204 
##           HEAVY SURF/HIGH SURF                    URBAN FLOOD 
##                            228                            249 
##                  FREEZING RAIN                    STORM SURGE 
##                            250                            261 
##                   RIP CURRENTS                           WIND 
##                            304                            340 
##                      AVALANCHE                     DUST STORM 
##                            386                            427 
##                    MARINE HAIL                    RIP CURRENT 
##                            442                            470 
##                            FOG                COLD/WIND CHILL 
##                            538                            539 
##                           SNOW                      LANDSLIDE 
##                            587                            600 
##              FLOOD/FLASH FLOOD               LAKE-EFFECT SNOW 
##                            624                            636 
##                  COASTAL FLOOD                   EXTREME COLD 
##                            650                            655 
##                 FLASH FLOODING                 TROPICAL STORM 
##                            682                            690 
##                      HIGH SURF                           HEAT 
##                            725                            767 
##        EXTREME COLD/WIND CHILL                 TSTM WIND/HAIL 
##                           1002                           1028 
##             WINTER WEATHER/MIX                      DENSE FOG 
##                           1104                           1293 
##                   FROST/FREEZE               WILD/FOREST FIRE 
##                           1342                           1457 
##                     HIGH WINDS                 EXCESSIVE HEAT 
##                           1533                           1678 
##                      ICE STORM                        DROUGHT 
##                           2006                           2488 
##                       BLIZZARD                       WILDFIRE 
##                           2719                           2761 
##           URBAN/SML STREAM FLD                    STRONG WIND 
##                           3392                           3566 
##                     WATERSPOUT       MARINE THUNDERSTORM WIND 
##                           3796                           5812 
##               MARINE TSTM WIND                   FUNNEL CLOUD 
##                           6175                           6839 
##                 WINTER WEATHER                   WINTER STORM 
##                           7026                          11433 
##                     HEAVY RAIN                     HEAVY SNOW 
##                          11723                          15708 
##                      LIGHTNING                      HIGH WIND 
##                          15754                          20212 
##             THUNDERSTORM WINDS                          FLOOD 
##                          20843                          25326 
##                    FLASH FLOOD                        TORNADO 
##                          54277                          60652 
##              THUNDERSTORM WIND                      TSTM WIND 
##                          82563                         219940 
##                           HAIL 
##                         288661
```

```r
## Calculate number of uniques
unique_evtype1 <- length(unique(data1$EVTYPE))
```

This initial analysis revealed ``985`` unique values for EVTYPE, an order of magnitude larger than the 48 types listed on pgs. 3-4 of the documentation. To address this issue, I first took the obvious steps: removing leading/ending spaces, reducing double spaces to single spaces, and changing the values of ```EVYTPE``` to upper-case.


```r
## copy event type, work with copy (so we don't overwrite the original data)
data1$EVTYPE2 <- data1$EVTYPE

## trim spaces, change multiple consecutive spaces to single space, change to upper-case
cleanup <- function (x) {
    x <- toupper(x) ## change to uppercase
    gsub("^\\s+|\\s+$","", x) ## replace leading/lagging spaces
    gsub("  "," ", x) ##replace double spaces with single spaces
    }
data1$EVTYPE2 <- cleanup(x=data1$EVTYPE2)

## remove all numbers, run cleanup again
data1$EVTYPE2 <- gsub("[0-9]","",data1$EVTYPE2)
data1$EVTYPE2 <- cleanup(x=data1$EVTYPE2)

## A function to remove special characters
library(stringr) 
rm_specials <- function(x, chars=c("-", "\\(", "\\)", "\\.")) {
    
    if (class(chars)!="character") stop('Error: char expected a character string. For example, try something like chars=c("a","b","c")')
    
    ## coerce chars to a list                                    
    chars <<- str_split(chars, " ", n= Inf) 
    
    ## remove hatever characters you fed to the function
    for (i in 1:length(chars)){
        x <- gsub(chars[[i]],"",x)
    }
    
    ## clean it up afterward
    x <- cleanup(x)
    
    return(x)
}

## Remove all special characters
data1$EVTYPE2 <- rm_specials(x=data1$EVTYPE2, chars=c("\\-", "\\(", "\\)", "\\."))

## Another condensing function. This one changes all strings containing a word to that word
rationalize <- function(x, strings) {
    
    if (class(strings)!="character") stop('Error: condense_it expected strings to be a character string. For example, try something like chars=c("a","b","c")')
    
    ## remove hatever characters you fed to the function
    for (i in 1:length(strings)){
        
        indx <- grep(strings[i], x)  ## get an index of locations containing this string. To avoid over-writing, only use starting value of strings
        
        x[indx] <- gsub("\\^", "",strings[i])
    }
    
    ## clean it up afterward
    x <- cleanup(x)
    return(x)
}

## Further rationalize the EVTYPE entries
data1$EVTYPE2 <- rationalize(x=data1$EVTYPE2, strings=c("ASTRONOMICAL LOW TIDE", "AVALANCHE", "BLIZZARD", "COASTAL FLOOD", "DEBRIS FLOW", "DENSE FOG", "DENSE SMOKE", "DROUGHT", "DUST STORM", "DUST DEVIL", "EXCESSIVE HEAT", "EXTREME COLD/WIND CHILL", "FLASH FLOOD", "^FLOOD", "FREEZING FOG", "FROST/FREEZE", "FUNNEL CLOUD", "HEAVY RAIN", "HEAVY SNOW", "HIGH SURF", "^HIGH WIND", "HURRICANE/TYPHOON", "ICE STORM", "LAKESHORE FLOOD", "LAKE EFFECT SNOW", "LIGHTNING", "MARINE HAIL", "MARINE HIGH WIND", "MARINE STRONG WIND", "MARINE THUNDERSTORM WIND", "RIP CURRENT", "SEICHE", "SLEET", "STORM TIDE", "^STRONG WIND", "^THUNDERSTORM WIND", "TORNADO", "TROPICAL DEPRESSION", "TROPICAL STORM", "TSUNAMI", "VOLCANIC ASH", "WATERSPOUT", "WILDFIRE", "WINTER STORM", "WINTER WEATHER", "SUMMARY"))
unique_evtype5 <- length(unique(data1$EVTYPE2))

## Write a function to allow search-and-replace type rationalization (for special cases)
rationalize2 <- function(x,lookup, replacement) {
    
    ## take the [i] value from lookup, replace the whole string with [i] from replacement
    
    ## swap replacement[i] for lookup[i]
    for (i in 1:length(lookup)){
        
        indx <- grep(lookup[i], x)  ## get an index of locations containing this string
        #x[indx] <- gsub(lookup[i],gsub("\\$", "",gsub("\\^", "",replacement[i])),x)
        x[indx] <- replacement[i]
    }
    
    ## clean it up afterward
    x <- cleanup(x)
    return(x)
}

## Address Some Special Cases
data1$EVTYPE2 <- rationalize2(x=data1$EVTYPE2, lookup = c("HURRICANE", "TYPHOON", "VOLCANIC", "THUNDERSTORM WINS", "MICROBURST", "GUSTNADO", "DOWNBURST", "^THUNDERSTORMWINDS", "^TSTMW", "^THUNDERSTORMS WIND", "^TSTM WIND", "WILD/FOREST FIRE", "^THUNDERTORM WINDS", "URBAN AND SMALL", "URBAN SMALL","URBAN/SM", "UNSEASONABLY HOT", "UNSEASONABLY WARM", "^TSTM WND", "^THUNDERSTORM WINDS", "TORRENTIAL RAIN", "^THUNERSTORM WINDS", "LIGHTING", "LIGNTING", "DUST DEVEL", "DUSTSTORM", "DAM BREAK", "DAM FAILURE", "FLASH FLOODING", "FROST", "WATERSPROUT", "WATER SPOUT", "WAYTERSPOUT", "BLOWOUT", "APACHE COUNTY", "^THUNDERSTORMW", "^THUNDERSTROM W", "ICE FOG", "MICOBURST", "RECORD HIGH", "GUSTY", "FLASH FLOOODING", "SEVERE THUNDERSTORM", "L STREAM", "LAKEEFFECT SNOW", "BLOWING SNOW ", "BLOWING DUST", "BRUSH FIRE", "WILD FIRES", "URBAN FLOOD", "STREET FLOODING", "THUNDERSTORM W INDS", "^THUNDERSTORM WIND", "^THUNDESTORM WINDS", "^ TSTM WIND$", "MIRCOBURST", "MARINE TSTM WIND", "LIGNTNING", "^TSTM", "MONTH", "THUNDERTSORM", "^THUNDEERSTORM WINDS", "^THUDERSTORM WIND", "SEVERE COLD", "BEACH FLOOD", "COASTAL/TIDAL FLOOD", "COASTALFLOOD", "EXTREME WIND CHILL", "EXTREME WINDCHILL", "TIDAL FLOOD", "VOG", "HEAVY SHOWER", "EXCESSIVE RAIN", "EXCESSIVE SNOW", "AVALANCE", "^DRY", "CSTL FLOOD", "GRADIENT WIND", "HYP", "^MUD", "RECORD SNOW", "NORTHERN LIGHT", "^FUNNEL", "DROWNING", "BLACK ICE", "FIRST SNOW", "GRASS FIRE", "PATTERN", "NO SEVERE WEATHER", "NONE", "SAHARAN WALL CLOUD", "SEVERE TURBULENCE", "WAKE LOW WIND", "^WIND$"), replacement = c("HURRICANE/TYPHOON", "HURRICANE/TYPHOON", "VOLCANIC ASH", "THUNDERSTORM WIND", "THUNDERSTORM WIND", "THUNDERSTORM WIND", "THUNDERSTORM WIND", "THUNDERSTORM WIND", "THUNDERSTORM WIND", "THUNDERSTORM WIND", "THUNDERSTORM WIND", "WILDFIRE", "THUNDERSTORM WIND", "FLASH FLOOD", "FLASH FLOOD", "FLASH FLOOD", "HEAT", "HEAT", "THUNDERSTORM WIND", "THUNDERSTORM WIND", "HEAVY RAIN", "THUNDERSTORM WIND", "LIGHTNING", "LIGHTNING", "DUST DEVIL", "DUST STORM", "FLASH FLOOD", "FLASH FLOOD", "FLASH FLOOD", "FROST/FREEZE", "WATERSPOUT", "WATERSPOUT", "WATERSPOUT", "OTHER", "OTHER", "THUNDERSTORM WIND", "THUNDERSTORM WIND", "FREEZING FOG", "THUNDERSTORM WIND", "EXCESSIVE HEAT", "STRONG WIND", "FLASH FLOOD", "THUNDERSTORM WIND", "FLASH FLOOD", "LAKE EFFECT SNOW", "WINTER STORM", "DUST STORM", "WILDFIRE", "WILDFIRE", "FLASH FLOOD", "FLASH FLOOD", "THUNDERSTORM WIND", "THUNDERSTORM WIND", "THUNDERSTORM WIND", "THUNDERSTORM WIND", "THUNDERSTORM WIND", "THUNDERSTORM WIND", "LIGHTNING", "THUNDERSTORM WIND", "SUMMARY", "THUNDERSTORM WIND", "THUNDERSTORM WIND", "THUNDERSTORM WIND", "EXTREME COLD/WIND CHILL", "COASTAL FLOOD", "COASTAL FLOOD", "COASTAL FLOOD", "EXTREME COLD/WIND CHILL", "EXTREME COLD/WIND CHILL", "COASTAL FLOOD", "OTHER", "HEAVY RAIN", "HEAVY RAIN", "HEAVY SNOW", "AVALANCHE", "DROUGHT", "COASTAL FLOOD", "OTHER", "WINTER WEATHER", "DEBRIS FLOW", "HEAVY SNOW", "OTHER", "FUNNEL CLOUD", "OTHER", "OTHER", "WINTER WEATHER", "WILDFIRE", "OTHER", "OTHER", "OTHER", "DUST STORM", "OTHER", "OTHER", "OTHER"))
```

At this point, it became clear that the time required to complete this task was prohibitively long. If this were truly a report being prepared for FEMA or some other organization, I would have more than a week to do it. Given the very basic scope of this project, I decided to stop at this point and look at the frequencies of the remaining categories. These are given below.


```r
freqtable <- sort(table(as.factor(data1$EVTYPE2)))  ## Print it to the report
freqtable
```

```
## 
##                    TSTM WIND G                           WIND 
##                              1                              1 
##                              ?                 ABNORMALLY WET 
##                              1                              1 
##                   BEACH EROSIN              BITTER WIND CHILL 
##                              1                              1 
## BLOWING SNOW/EXTREME WIND CHIL               BREAKUP FLOODING 
##                              1                              1 
##                COASTAL EROSION                   COASTALSTORM 
##                              1                              1 
##                  COLD AND SNOW        COLD AND WET CONDITIONS 
##                              1                              1 
##                     COLD/WINDS                   COOL AND WET 
##                              1                              1 
##                     COOL SPELL                      DEEP HAIL 
##                              1                              1 
##                  DRIFTING SNOW                   EARLY FREEZE 
##                              1                              1 
##                     EARLY RAIN                      EXCESSIVE 
##                              1                              1 
##        EXCESSIVE PRECIPITATION              EXCESSIVE WETNESS 
##                              1                              1 
##                EXCESSIVELY DRY                  EXTENDED COLD 
##                              1                              1 
##                  EXTREMELY WET      FOG AND COLD TEMPERATURES 
##                              1                              1 
##                   FOREST FIRES  FREEZING DRIZZLE AND FREEZING 
##                              1                              1 
##         FREEZING RAIN AND SNOW                 FREEZING SPRAY 
##                              1                              1 
##                     HAIL ALOFT                  HAIL FLOODING 
##                              1                              1 
##                     HAIL STORM                 HAIL/ICY ROADS 
##                              1                              1 
##                     HAILSTORMS                 HAZARDOUS SURF 
##                              1                              1 
##                      HEATBURST            HEAVY PRECIPATATION 
##                              1                              1 
##            HEAVY SURF AND WIND                   HEAVY SWELLS 
##                              1                              1 
##                 HEAVY WET SNOW                           HIGH 
##                              1                              1 
##               HIGHWAY FLOODING                    HOT WEATHER 
##                              1                              1 
##                   ICE AND SNOW            ICE JAM FLOOD MINOR 
##                              1                              1 
##                    ICE ON ROAD                    ICE PELLETS 
##                              1                              1 
##                      ICE ROADS               ICE/STRONG WINDS 
##                              1                              1 
##                   LACK OF SNOW                     LAKE FLOOD 
##                              1                              1 
##               LARGE WALL CLOUD                    LATE FREEZE 
##                              1                              1 
##               LATE SEASON HAIL               LATE SEASON SNOW 
##                              1                              1 
##            LATESEASON SNOWFALL     LIGHT SNOW/FREEZING PRECIP 
##                              1                              1 
##                 LIGHT SNOWFALL                    LOCAL FLOOD 
##                              1                              1 
##         LOW TEMPERATURE RECORD                 LOW WIND CHILL 
##                              1                              1 
##                MARINE ACCIDENT              METRO STORM, MAY  
##                              1                              1 
##                    MINOR FLOOD                  MODERATE SNOW 
##                              1                              1 
##                 MOUNTAIN SNOWS          NONSEVERE WIND DAMAGE 
##                              1                              1 
##                   NONTSTM WIND                     PATCHY ICE 
##                              1                              1 
##              PROLONG COLD/SNOW                  RAIN AND WIND 
##                              1                              1 
##                    RAIN DAMAGE                     RAIN HEAVY 
##                              1                              1 
##                      RAIN/WIND                      RAINSTORM 
##                              1                              1 
##           RAPIDLY RISING WATER      RECORD COLD AND HIGH WIND 
##                              1                              1 
##               RECORD HEAT WAVE                RECORD MAY SNOW 
##                              1                              1 
##           RECORD PRECIPITATION                    RECORD WARM 
##                              1                              1 
##              RECORD WARM TEMPS                     ROGUE WAVE 
##                              1                              1 
##              SEASONAL SNOWFALL                  SNOW ADVISORY 
##                              1                              1 
##                  SNOW AND WIND      SNOW HIGH WIND WIND CHILL 
##                              1                              1 
##              SNOW/ BITTER COLD                      SNOW/ ICE 
##                              1                              1 
##                      SNOW/RAIN                     SNOW\\COLD 
##                              1                              1 
##                SNOWFALL RECORD                      SNOWSTORM 
##                              1                              1 
##                      SOUTHEAST              STORM FORCE WINDS 
##                              1                              1 
##                STREAM FLOODING            THUNDERESTORM WINDS 
##                              1                              1 
##                    THUNDERSNOW             THUNDERSNOW SHOWER 
##                              1                              1 
##         THUNDERSTORM DAMAGE TO              THUNDERSTORM HAIL 
##                              1                              1 
##                        TORNDAO               TUNDERSTORM WIND 
##                              1                              1 
##              UNSEASONABLE COLD            UNUSUALLY LATE SNOW 
##                              1                              1 
##                      VERY WARM            WARM DRY CONDITIONS 
##                              1                              1 
##                   WARM WEATHER                       WET SNOW 
##                              1                              1 
##                    WET WEATHER                  WIND AND WAVE 
##                              1                              1 
##           WIND CHILL/HIGH WIND                     WIND STORM 
##                              1                              1 
##                      WIND/HAIL                            WND 
##                              1                              1 
##                 ABNORMALLY DRY     BELOW NORMAL PRECIPITATION 
##                              2                              2 
##                  COASTAL SURGE               COLD AIR FUNNELS 
##                              2                              2 
##               COLD TEMPERATURE                 EXCESSIVE COLD 
##                              2                              2 
##               FALLING SNOW/ICE                      GLAZE ICE 
##                              2                              2 
##                    HAIL DAMAGE                     HAIL/WINDS 
##                              2                              2 
##                     HEAT WAVES                     HEAVY SEAS 
##                              2                              2 
##                     HIGH TIDES                    HOT AND DRY 
##                              2                              2 
##                      HOT SPELL                       HVY RAIN 
##                              2                              2 
##                      ICE FLOES                      LANDSLUMP 
##                              2                              2 
##                      LANDSPOUT           LATE SEASON SNOWFALL 
##                              2                              2 
##                      LATE SNOW                  MARINE MISHAP 
##                              2                              2 
##                  NON TSTM WIND                 RECORD DRYNESS 
##                              2                              2 
##            RECORD LOW RAINFALL              RED FLAG CRITERIA 
##                              2                              2 
##               RED FLAG FIRE WX              REMNANTS OF FLOYD 
##                              2                              2 
##         RIVER AND STREAM FLOOD                     ROCK SLIDE 
##                              2                              2 
##                    RURAL FLOOD              SNOW ACCUMULATION 
##                              2                              2 
##                  SNOW AND COLD                      SNOW/COLD 
##                              2                              2 
##                SNOW/HIGH WINDS            THUNDERSTORM DAMAGE 
##                              2                              2 
##        UNSEASONABLY COOL & WET            UNSEASONAL LOW TEMP 
##                              2                              2 
##                UNSEASONAL RAIN          UNUSUAL/RECORD WARMTH 
##                              2                              2 
##                       VERY DRY                    WINTERY MIX 
##                              2                              2 
## BITTER WIND CHILL TEMPERATURES                      COLD WAVE 
##                              3                              3 
##                     EARLY SNOW                      HAIL/WIND 
##                              3                              3 
##                      HAILSTORM            HEAVY PRECIPITATION 
##                              3                              3 
##        HIGH TEMPERATURE RECORD                     HIGH WAVES 
##                              3                              3 
##            LIGHT SNOW/FLURRIES                    MAJOR FLOOD 
##                              3                              3 
##           NORMAL PRECIPITATION             RECORD WINTER SNOW 
##                              3                              3 
##                     ROUGH SEAS                   STREET FLOOD 
##                              3                              3 
##                      WHIRLWIND                     WIND GUSTS 
##                              3                              3 
##                     WINTER MIX                ABNORMAL WARMTH 
##                              3                              4 
##           ACCUMULATED SNOWFALL                  BEACH EROSION 
##                              4                              4 
##                COLD AIR FUNNEL              COLD TEMPERATURES 
##                              4                              4 
##                   COLD WEATHER            EXTREME/RECORD COLD 
##                              4                              4 
##             FREEZING RAIN/SNOW                        ICE JAM 
##                              4                              4 
##                 MINOR FLOODING                 PROLONG WARMTH 
##                              4                              4 
##                 PROLONGED RAIN                     RECORD LOW 
##                              4                              4 
##                     ROUGH SURF                   SAHARAN DUST 
##                              4                              4 
##                  THUNDERSTORMS                 UNUSUALLY WARM 
##                              4                              4 
##                       WET YEAR               ICE JAM FLOODING 
##                              4                              5 
##                       ICE/SNOW                      RAIN/SNOW 
##                              5                              5 
##                    RECORD COOL            RECORD TEMPERATURES 
##                              5                              5 
##            ROTATING WALL CLOUD              SNOWMELT FLOODING 
##                              5                              5 
##                     WALL CLOUD            AGRICULTURAL FREEZE 
##                              5                              6 
##   COLD WIND CHILL TEMPERATURES                    HIGH SWELLS 
##                              6                              6 
##                     HIGH WATER                   SNOW SHOWERS 
##                              6                              6 
##             SNOW/FREEZING RAIN                 EARLY SNOWFALL 
##                              6                              7 
##                    HARD FREEZE                LOW TEMPERATURE 
##                              7                              7 
##                NON SEVERE HAIL              SNOW/BLOWING SNOW 
##                              7                              7 
##                       SNOW/ICE                DAMAGING FREEZE 
##                              7                              8 
##                      HEAVY MIX                      HIGH SEAS 
##                              8                              8 
##                     LANDSLIDES                 UNUSUALLY COLD 
##                              8                              8 
##                  COASTAL STORM                    DENSE SMOKE 
##                             10                             10 
##                   MIXED PRECIP                 UNUSUAL WARMTH 
##                             10                             10 
##                          SMOKE             SNOW FREEZING RAIN 
##                             11                             11 
##              UNSEASONABLY COOL                  WIND ADVISORY 
##                             12                             12 
##                RECORD RAINFALL                           RAIN 
##                             14                             16 
##             RECORD TEMPERATURE                   BLOWING SNOW 
##                             16                             17 
##                     WIND CHILL                    SNOW SQUALL 
##                             18                             19 
##               UNSEASONABLY WET                        TSUNAMI 
##                             19                             20 
##                         SEICHE                   EXTREME HEAT 
##                             21                             22 
##                   PROLONG COLD                   SNOW SQUALLS 
##                             22                             22 
##                LAKESHORE FLOOD            LIGHT FREEZING RAIN 
##                             23                             23 
##              UNSEASONABLY COLD               FREEZING DRIZZLE 
##                             23                             24 
##                HEAVY LAKE SNOW                 RIVER FLOODING 
##                             25                             29 
##                   VOLCANIC ASH                    WIND DAMAGE 
##                             29                             31 
##                      ICY ROADS                   SNOW AND ICE 
##                             32                             34 
##                    DEBRIS FLOW                          WINDS 
##                             36                             36 
##            MIXED PRECIPITATION                          GLAZE 
##                             37                             43 
##             TEMPERATURE RECORD                   THUNDERSTORM 
##                             43                             45 
##                   FREEZING FOG             MARINE STRONG WIND 
##                             48                             48 
##                     SMALL HAIL               UNSEASONABLY DRY 
##                             53                             56 
##            TROPICAL DEPRESSION                            ICE 
##                             60                             61 
##                    RECORD COLD                      HEAT WAVE 
##                             68                             75 
##                         FREEZE                           COLD 
##                             76                             82 
##                    RECORD HEAT                     HEAVY SURF 
##                             82                             87 
##                     WINTRY MIX                          HAIL  
##                             94                             99 
##              MODERATE SNOWFALL         ASTRONOMICAL HIGH TIDE 
##                            101                            103 
##                          SLEET               MARINE HIGH WIND 
##                            120                            135 
##                        SUMMARY               STORM SURGE/TIDE 
##                            136                            148 
##                     DUST DEVIL                  RECORD WARMTH 
##                            151                            154 
##                    RIVER FLOOD          ASTRONOMICAL LOW TIDE 
##                            173                            174 
##                     LIGHT SNOW                  FREEZING RAIN 
##                            176                            260 
##                    STORM SURGE              HURRICANE/TYPHOON 
##                            261                            299 
##                      AVALANCHE                     DUST STORM 
##                            388                            434 
##                    MARINE HAIL                          OTHER 
##                            442                            449 
##                            FOG                COLD/WIND CHILL 
##                            538                            539 
##                      LANDSLIDE                           SNOW 
##                            600                            617 
##                   EXTREME COLD               LAKE EFFECT SNOW 
##                            657                            659 
##                 TROPICAL STORM                    RIP CURRENT 
##                            697                            777 
##                  COASTAL FLOOD                           HEAT 
##                            884                            921 
##                      HIGH SURF        EXTREME COLD/WIND CHILL 
##                            968                           1234 
##                      DENSE FOG                   FROST/FREEZE 
##                           1296                           1413 
##                 EXCESSIVE HEAT                      ICE STORM 
##                           1692                           2027 
##                        DROUGHT                       BLIZZARD 
##                           2538                           2744 
##                     WATERSPOUT                    STRONG WIND 
##                           3847                           3876 
##                       WILDFIRE       MARINE THUNDERSTORM WIND 
##                           4236                           5812 
##                   FUNNEL CLOUD                 WINTER WEATHER 
##                           6982                           8172 
##                   WINTER STORM                     HEAVY RAIN 
##                          11442                          11826 
##                      LIGHTNING                     HEAVY SNOW 
##                          15777                          15836 
##                      HIGH WIND                          FLOOD 
##                          21785                          25471 
##                    FLASH FLOOD                        TORNADO 
##                          59518                          60700 
##                           HAIL              THUNDERSTORM WIND 
##                         288662                         331155
```

At this point, I decided to make a few more value substitutions (where the mapping was obvious), and to cut my losses and turn the rest of the categories into "OTHER". The frequency table above gives some initial indication of the impact of this shortcut. I understand that there are better ways to accomplish this data cleaning stage, but I honestly cannot think of any that would work in the time given for this project. If you have suggestions, I encourage you to contact me on [LinkedIN](http://www.linkedin.com/in/jameslamb1/) and share your thoughts.


```r
## One final set of special-case mappings
data1$EVTYPE2 <- rationalize2(x=data1$EVTYPE2, lookup = c("LANDSLIDE", "^FOG$", "FREEZING RAIN", "STORM SURGE", "RIVER FLOOD", "^SMALL HAIL", "^THUNDERSTORM$", "EXTREME HEAT", "^FREEZE$", "RECORD RAIN", "^THUNDERESTORM WINDS", "TORNDAO", "SAHARAN DUST", "RIVER AND STREAM FLOOD", "RECORD WARM", "RECORD HEAT", "RAPIDLY RISING WATER",  "HVY RAIN", "^EXTREME COLD$", "RECORD COLD", "HEAVY SURF", "^THUNDERSTORM^", "HEAVY LAKE SNOW", "UNSEASONABLY COLD", "ICE JAM FLOOD", "MAJOR FLOOD", "STREET FLOOD", "UNUSUALLY COLD", "HIGH TIDE", "THUNDERSTORM DAMAGE", "COLD WIND CHILL TEMPERATURES", "LOCAL FLOOD", "SNOW HIGH WIND WIND CHILL", "MINOR FLOOD", "BITTER WIND CHILL", "HEAVY WET SNOW", "FOREST FIRE", "DEEP HAIL", "SNOW/HIGH WINDS", "ROCK SLIDE", "THUNDERSTORM HAIL", "HIGHWAY FLOODING", "COASTALSTORM", "BITTER WIND CHILL", "HAZARDOUS SURF", "^SNOW", "^TUNDERSTORM WIND", "\\?" ), replacement = c("DEBRIS FLOW", "DENSE FOG", "WINTER WEATHER", "STORM SURGE/TIDE", "FLOOD", "HAIL", "THUNDERSTORM WIND", "EXCESSIVE HEAT", "FROST/FREEZE", "HEAVY RAIN", "THUNDERSTORM WIND", "TORNADO", "DUST STORM", "FLOOD", "EXCESSIVE HEAT", "EXCESSIVE HEAT", "FLASH FLOOD", "HEAVY RAIN", "EXTREME COLD/WIND CHILL", "COLD/WIND CHILL", "HIGH SURF", "THUNDERSTORM WIND", "LAKE EFFECT SNOW", "COLD/WIND CHILL", "FLOOD", "FLOOD", "FLASH FLOOD", "COLD/WIND CHILL", "HIGH SURF", "THUNDERSTORM WIND", "COLD/WIND CHILL", "FLOOD", "WINTER STORM", "FLOOD", "EXTREME COLD/WIND CHILL", "HEAVY SNOW", "WILD FIRE", "HAIL", "WINTER STORM", "DEBRIS FLOW", "HAIL", "FLOOD", "TSUNAMI", "EXTREME COLD/WIND CHILL", "HIGH SURF", "WINTER WEATHER", "THUNDERSTORM WIND", "OTHER"))

## Change everything else to "OTHER"
checklist <- unique(data1$EVTYPE2)
main_types <- c("ASTRONOMICAL LOW TIDE", "AVALANCHE", "BLIZZARD", "COASTAL FLOOD", "COLD/WIND CHILL", "DEBRIS FLOW", "DENSE FOG", "DENSE SMOKE", "DROUGHT", "DUST DEVIL", "DUST STORM", "EXCESSIVE HEAT", "EXTREME COLD/WIND CHILL", "FLASH FLOOD", "FLOOD", "FROST/FREEZE", "FUNNEL CLOUD", "FREEZING FOG", "HAIL", "HEAT", "HEAVY RAIN", "HEAVY SNOW", "HIGH SURF", "HIGH WIND", "HURRICANE/TYPHOON", "ICE STORM", "LAKE EFFECT SNOW", "LAKESHORE FLOOD", "LIGHTNING", "LIGHTNING", "MARINE HAIL", "MARINE HIGH WIND", "MARINE STRONG WIND", "MARINE THUNDERSTORM WIND", "RIP CURRENT", "SEICHE", "SLEET", "STORM SURGE/TIDE", "STRONG WIND", "THUNDERSTORM WIND", "TORNADO", "TROPICAL DEPRESSION", "TROPICAL STORM", "TSUNAMI", "VOLCANIC ASH", "WATERSPOUT", "WILDFIRE", "WINTER STORM", "WINTER WEATHER", "SUMMARY")

for (i in 1:length(unique(data1$EVTYPE2))) {
    if ((checklist[i] %in% main_types)==FALSE){
        temp <- paste("^", checklist[i], "$", sep="")
        indx <- grep(temp, data1$EVTYPE2) ## make sure we're not over-writing aything we don't want to
        data1$EVTYPE2[indx] <- "OTHER"
    }
}
unique_evtype6 <- length(unique(data1$EVTYPE2))

##Print a frequency table of the unique types
freqtable <- sort(table(as.factor(data1$EVTYPE2)))
freqtable
```

```
## 
##              DENSE SMOKE                   SEICHE                  TSUNAMI 
##                       10                       21                       21 
##          LAKESHORE FLOOD             VOLCANIC ASH             FREEZING FOG 
##                       23                       29                       48 
##       MARINE STRONG WIND      TROPICAL DEPRESSION                    SLEET 
##                       48                       60                      120 
##         MARINE HIGH WIND                  SUMMARY               DUST DEVIL 
##                      135                      136                      151 
##    ASTRONOMICAL LOW TIDE        HURRICANE/TYPHOON                AVALANCHE 
##                      174                      299                      388 
##         STORM SURGE/TIDE               DUST STORM              MARINE HAIL 
##                      409                      438                      442 
##              DEBRIS FLOW          COLD/WIND CHILL         LAKE EFFECT SNOW 
##                      646                      649                      684 
##           TROPICAL STORM              RIP CURRENT            COASTAL FLOOD 
##                      697                      777                      884 
##                     HEAT                HIGH SURF             FROST/FREEZE 
##                      921                     1162                     1489 
##                DENSE FOG  EXTREME COLD/WIND CHILL           EXCESSIVE HEAT 
##                     1834                     1895                     1955 
##                    OTHER                ICE STORM                  DROUGHT 
##                     1960                     2027                     2538 
##                 BLIZZARD               WATERSPOUT              STRONG WIND 
##                     2744                     3847                     3876 
##                 WILDFIRE MARINE THUNDERSTORM WIND             FUNNEL CLOUD 
##                     4236                     5812                     6982 
##           WINTER WEATHER             WINTER STORM               HEAVY RAIN 
##                     9208                    11445                    11842 
##                LIGHTNING               HEAVY SNOW                HIGH WIND 
##                    15777                    15837                    21785 
##                    FLOOD              FLASH FLOOD                  TORNADO 
##                    25691                    59522                    60701 
##                     HAIL        THUNDERSTORM WIND 
##                   288717                   331205
```

After taking all these steps, I was left with ``50` unique values in the "EVTYPE", the 48 event types listed in the documentation plus two classes I added, "OTHER" and "SUMMARY". "OTHER" holds all observations which I was not able to classify with any confidence and "SUMMARY" contains observations labeled as monthly or quarterly summaries of damage. 

I made the assumption that the "SUMMARY" entries contained summary statistics for given regions and time periods, and that including these observations would double-count some storms. As a result, the final datacleaning step involved removing all of the summary observations. In this step, I also changed EVTYPE2 to a factor, for use in graphing in summarizing.


```r
## Remove "SUMMARY" observations from the dataset
finaldata <- data1[(data1$EVTYPE2 == "SUMMARY")==FALSE,]

## Change "EVTYPE2" to a factor variable for graphing
finaldata$EVTYPE2 <- as.factor(finaldata$EVTYPE2)
```

###III. Results

With the data cleaned and ready for analysis, I performed two very quick analyses. Please see concluding remarks for other types of analysis I would have conducted, given more time to complete the assignment and some incentive to be thorough/complete.

####A. WhiCH Types of Events are Most Harmful with Respect to Population Health?

To assess the health effects of events, I examined only fatalities and injuries, referred to as ```FATALITIES``` and ```INJURIES```. I did not consider direct vs. indirect causal links, I did not examine the time-series characteristics of these relationships, and I did not investigate other factors which might amplify the health effects of storms (such as quality of medical care or quality of emergency-response organizations).


```r
## Organize the data by total fatalities
fataldata1 <- aggregate(FATALITIES ~ EVTYPE2, data=finaldata, na.rm=TRUE, sum)
    fataldata1 <- fataldata1[order(-fataldata1$FATALITIES),] ## sort by most fatalities
    names(fataldata1) <- c("EVTYPE", "TOTAL.FATALITIES")
    head(fataldata1)  ## print first five rows
```

```
##               EVTYPE TOTAL.FATALITIES
## 41           TORNADO             5661
## 12    EXCESSIVE HEAT             2018
## 14       FLASH FLOOD             1065
## 20              HEAT              977
## 29         LIGHTNING              817
## 40 THUNDERSTORM WIND              723
```

```r
fataldata2 <- aggregate(FATALITIES ~ EVTYPE2, data=finaldata, na.rm=TRUE, mean)
     fataldata2 <- fataldata2[order(-fataldata2$FATALITIES),] ## sort by highest average fatalities
    names(fataldata2) <- c("EVTYPE", "MEAN.FATALITIES")
    head(fataldata2)  ## print first five rows
```

```
##               EVTYPE MEAN.FATALITIES
## 44           TSUNAMI          1.6190
## 20              HEAT          1.0608
## 12    EXCESSIVE HEAT          1.0322
## 35       RIP CURRENT          0.7426
## 2          AVALANCHE          0.5799
## 25 HURRICANE/TYPHOON          0.4515
```

The data suggest that tornadoes have caused the most cumulative deaths over the data period (1950-2011), while tsunamies, when they appear, tend to cause the most fatalities per event on average. As you can see, though, over 1000 deaths were tied to events categorized as "OTHER", meaning that beyond the top 1 or 2 spots, the data quality issues in this dataset raise serious credibility questions. It also might be the case that certain types of storms, like tornadoes, were more likely to be reported in earlier periods of the data.

It should also be noted that this analysis does not consider population density, emergency response quality, or other factors which might impact the health impact potential of a particular storm. Keeping all these data weaknesses in mind, I next turned my attention to another aspect of health: storm-related injuries.


```r
## Organize the data by total fatalities
injurydata1 <- aggregate(INJURIES ~ EVTYPE2, data=finaldata, na.rm=TRUE, sum)
    injurydata1 <- injurydata1[order(-injurydata1$INJURIES),] ## sort by most cumulative injuries
    names(injurydata1) <- c("EVTYPE", "TOTAL.INJURIES")
    head(injurydata1, n=5)  ## print first five rows
```

```
##               EVTYPE TOTAL.INJURIES
## 41           TORNADO          91407
## 40 THUNDERSTORM WIND           9545
## 15             FLOOD           6794
## 12    EXCESSIVE HEAT           6730
## 29         LIGHTNING           5232
```

```r
injurydata2 <- aggregate(INJURIES ~ EVTYPE2, data=finaldata, na.rm=TRUE, mean)
    injurydata2 <- injurydata2[order(-injurydata2$INJURIES),] ## sort by highest average injuries per event
    names(injurydata2) <- c("EVTYPE", "MEAN.INJURIES")
    head(injurydata2, n=5)  ## print first five rows
```

```
##               EVTYPE MEAN.INJURIES
## 44           TSUNAMI         6.143
## 25 HURRICANE/TYPHOON         4.458
## 12    EXCESSIVE HEAT         3.442
## 20              HEAT         2.299
## 41           TORNADO         1.506
```

The picture for injuries is very similar to the one for fatalities. Tornadoes contributed, by far, the most cumulative injuries over the data period, with nearly 91,500 injuries caused. Note again, however, that over 10,000 injuries were classified as "OTHER", suggesting that much work needs to be done on the data cleaning step before we can make credible claims about the relative impacts of different types of storm events on health. 

The average figures, which show the average number of injuries per occurrence of a given event type, suggest that Tsunamis and Hurricanes tend to be the most harmful, on average. Excessive heat and above-average heat are the next worst offenders. The same caveats about data quality apply. The average figures might be better understood graphically, as shown below.


```r
## Barplot of average injuries
rownames(injurydata2) <- injurydata2$EVTYPE

## Subset just what we want to plot
injurydata2graph <- head(injurydata2, n = 10)
barplot(height=injurydata2graph$MEAN.INJURIES, main = "Fig. 1 Average Injuries Caused By Different Weather Event Types", horiz=TRUE, legend = rownames(injurydata2graph), beside=TRUE, col = c("red", "blue", "brown", "darkgrey", "azure", "cyan", "aquamarine", "coral3", "green", "darkorange"))
```

![plot of chunk sec2plot](./PA2_template_files/figure-html/sec2plot.png) 

This preliminary analysis suggests that tornadoes tend to cause the most population health damage, though the analysis suffers from many of the weaknesses described in this section, previous sections, and the concluding remarks at the end of the paper.

####B. Which Types of Events Have the Greatest Economic Consequences?

After investigating human population consequences, I turned my attention to the economic consequences of storms. I consider a limited definition of "Total Damage", given as the sum of crop damange and property damange.


```r
## Calculate total damage
finaldata$TOTDMG <- (finaldata$CROPDMG + finaldata$PROPDMG)

## Organize the data by total fatalities
dmgdata1 <- aggregate(TOTDMG ~ EVTYPE2, data=finaldata, na.rm=TRUE, sum)
    dmgdata1 <- dmgdata1[order(-dmgdata1$TOTDMG),] ## sort by most cumulative damage
    names(dmgdata1) <- c("EVTYPE", "TOTAL DAMAGE")
    head(dmgdata1)  ## print first five rows
```

```
##               EVTYPE TOTAL DAMAGE
## 41           TORNADO      3315779
## 40 THUNDERSTORM WIND      2878917
## 14       FLASH FLOOD      1709947
## 19              HAIL      1270147
## 15             FLOOD      1099317
## 29         LIGHTNING       607268
```

```r
dmgdata2 <- aggregate(TOTDMG ~ EVTYPE2, data=finaldata, na.rm=TRUE, mean)
    dmgdata2 <- dmgdata2[order(-dmgdata2$TOTDMG),] ## sort by highest average damage
    names(dmgdata2) <- c("EVTYPE", "MEAN TOTAL DAMAGE")
    head(dmgdata2)  ## print first five rows
```

```
##               EVTYPE MEAN TOTAL DAMAGE
## 25 HURRICANE/TYPHOON            123.16
## 43    TROPICAL STORM             80.92
## 38  STORM SURGE/TIDE             66.08
## 41           TORNADO             54.62
## 36            SEICHE             46.67
## 44           TSUNAMI             44.06
```

Using this very crude measure of economic impact, it appears that tornadoes had the most cumulative impact over the sample, at over $3.3 million dollars. There is clearly a sever scaling problem hear (I'm guessing it has something to do with the way that damage estimates are entered), but I did not have time to address it. Note also that the "OTHER" category came in second place, suggesting once again that data quality issues plague this analysis.

Hurricanes, tropical storms, and storm surges were the most damaging on average. This suggests that, at least by this very crude measure of economic impact, these storms are more damaging when they happen, but their exclusion from the top of the cumulative damage rankings might suggest that they are much more infrequent.


###IV. Concluding Remarks

I apologize to you, my graders/ readers, for the sloppiness of this report. The amount of busy-work and unrealistic expectations of the project layout (as I understand it) severely hurt this report.  Like many of you taking this course, I am a working professional and my time is limited. I devoted 25 hours to this project, an enormous amount of time. If I were actually preparing a report for a government agency (like FEMA), I would surely have much more time to work through this dataset and would produce a far better report. With more time, I would have: 

- Performed more thorough investigation of poorly-coded events and more careful re-coding
- Investigated the time-series characteristics of storm damage
- Familiarized myself with all the variabels in the dataset, possibly leading to regression or factor analysis
- Investigated data quality over time and chosen a temporal subset to analyze (the description noted that early data are less reliable)
- Converted dollar-denominated figures to real dollars for more credible comparison of economic impacts
- Expanded the definition of "economic impact" to account for the price of insurance, home prices, and other economic variables 
- Created better, non-overlapping event type categories to unearth actionable insights

I invite you to share your comments/criticisms in the peer grading form or by contacting me via LinkedIN, and I look forward to your suggestions. But know, as you grade me, that this is far from my best work, and its quality is a direct result of the time constraints in my professional life.

###REFERENCES

In this type of project, novice users like me inevitably end up scouring Inside-R, Stack, CRAN, r-bloggers, and elsewhere in search of helpful hints and solutions to error messages. The links below are presented to give credit where credit is due. I hope that you find them as useful as I did.

[1] https://stat.ethz.ch/R-manual/R-devel/library/base/html/chartr.html

[2] http://www.statmethods.net/stats/frequencies.html

[3] http://stackoverflow.com/questions/19890633/r-produces-unsupported-url-scheme-error-when-getting-data-from-https-sites

[4] http://stackoverflow.com/questions/17185550/removing-certain-pattern-from-a-string

[4] https://stat.ethz.ch/R-manual/R-devel/library/base/html/regex.html

[6] http://www.inside-r.org/packages/cran/stringr/docs/str_split

[7] https://stat.ethz.ch/pipermail/r-help/2002-September/025359.html

