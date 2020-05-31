#!/bin/bash

#Author: Bianca Van Der Merwe
#ID: 10389192
#!/bin/bash
# Bash Menu Script Example

#version 10, stuggled with part 3 and 4.struggling with range() set).



specificDown()          #name of my specific dowloand function
{
 echo "The aim is to be able to download a specific thumbnail"

curl -s "https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152" > specificdownload.txt        #download all the hmtl text into a new textfile called specificdownload.txt
cat specificdownload.txt | grep -Eo '(http|https)://[^"]+' | grep ".jpg" | sed 's/.*\///' > spfdownlist.txt         #using the specificdownload.txt, grep removes all the http(s):// that it can find
                                                                                                                    #grep then finds everything that has ".jpg" in it, and removes everything before the last "/
                                                                                                                    #this is then written to a new file to save the nicely named file of  spfdownlist.txt
while true; do                                                                                          #entering a while loop, easier way to handle if they have not entered the correct thing
read -p "what is the number of the thumbnail you wouldlike to downlaod ? DSC0_____: " thumbspfd         #obtaining the user's response
startspfd="DSC0"$thumbspfd                                                                              # adding on a DSCinfront og the users input
endspfd=$startspfd".jpg"                                                                                #adding on the .jpg end for the user
    if  grep -q $endspfd  "spfdownlist.txt" ; then                                                    #if the  input is within the text file do the following
        wget -qO - "https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152" | 
        grep "$startspfd "|cut -d\" -f2| echo "Downloading $startspfd, with the file name of $endspfd.......File Download Complete"
                                                                                                        #using wget, get all addresss from the address
                                                                                                        #use grep to find anything that matches the user input with the added DSC infront
        echo "PROGRAM FINISHED"             #to display to user that this section of work is complete
        exit 1                              #to stop this part of download
    else
        echo "Please only enter 4 digits. eg 1565 "     #if the user has emnetered anytyhing other than digits, an error will be display asking a correct input.
    fi                  #stopping the if statement
done                    #stopping the while true loop
}

allDown()                     #name of function that downloads all images found on the website                      
{
    echo -e "You have chosen to download all thumnails. \nDownloading will commence shortly."       #have printed this to allow the uer to see that what they have chosen
    curl -s "https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152" > alld.txt #download all the hmtl text into a new textfile called alldownload.txt
    cat alld.txt | grep -Eo '(http|https)://[^"]+' | grep ".jpg" | sed 's/.*\///' > alldlist.txt        #using the alldownload.txt, grep removes all the http(s):// that it can find

    wget -qO - "https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152" | 
    grep '.jpg"'|cut -d\" -f4|while read thumbnailID; do echo "Downloading $thumbnailID, with the file name $thumbnailID.jpg .... File Download Complete ";  wget -q -c $thumbnailID ; done
                            # using wget with everything that is in this site, we grap everything that has .jpg in it.
                            #after we have it we delete everything except for the 4th value (after the second =)
                            #I have named that variable thumbanilID as it does make refering to that image easier
                            #I eneter a while lopp toprint out for each thumnail that is it busy downloading, if the user stops downloading it will be pause and conitnue to print from that line
    echo "PROGRAM FINISHED"   #after all the images have been downloaded, print tat it is finished  
}

randir()
{
    echo "The aim is to be able to download ALL IN RANGE thumbnais"
    

    curl -s "https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152" > rand.txt        #writting the html text into the rand.txt file
    cat rand.txt | grep -Eo '(http|https)://[^"]+' | grep ".jpg" | sed 's/.*\///' | sed -e 's/^DSC0//' | sed -e 's/.jpg$//' > randlist.txt      
                                            #while looking at the rand.txt file, stip out all the html, look at everything that has the .jpg on the end
                                            #using sed - delete everything that starts with DS0 and ends with .jpg save it to randlist.txt

    awk 'BEGIN {FS="^"; print "\n"}{ ORS=" "; print "\t"}{print ; if(++onr%10 == 0) print "\n"}' randlist.txt #while using the file seperate, print that on a new line
                                                                                                                # Output record separator prints a space between the output, and tab's then to the righy
                                                                                                                #in one line, if the vairables are more than 10 print it in a new line.
    echo -e "\n\n"  #printed a new line for visual purposes

    while true; do
    read -p "What is the start of your range: " minrange            #Setting lower bound
    minexists=$( grep $minrange "randlist.txt" | wc -l )            #testing if lower bound is in my list
    if [[ $minexists -eq 0 ]]; then                              #if it is not in my list, then print out saying that it is invalid
        echo -e "This is not a valid thumbnai name. Please try again. \n"
    else
        echo "The start of the rang is set to DSC0$minrange.jpg"      #if it is in my list, print out saying that it is in my listvand the start of the range is set
        break     
    fi
    done

    while true; do
    read -p "What is the end of your range: " maxrange              #Setting upper bound
    maxexists=$( grep $maxrange "randlist.txt" | wc -l )         #testing if upper bound is in my list
    if [[ $maxexists -eq 0 ]]; then                          #if it is not in my list, then print out saying that it is invalid
        echo -e "This is not a valid thumbnai name. Please try again. \n"
    else
        echo "The end of the rang is set to DSC0$maxrange.jpg"    #if it is in my list, print out saying that it is in my listvand the start of the range is set
        break
    fi
    done

    for ((i = $minrange ; i <= $maxrange ; i++)); do
    isinlist=$( grep $i "randlist.txt" | wc -l )
        if [[ $isinlist -eq 0 ]]; then #if it is not in my list, ignore the rest
            continue
        else
            wget - qO -"https://secure.ecu.edu.au/service-centres/MACSC/gallery/152/DSC0$i.jpg"| echo "Downloading DSC0$i, with the file name of DSC0$i.jpg .......File Download Complete"     
            #if it is in my list, download and print out that I am downloading this file
        fi
    done
    echo "PROGRAM FINSIHED" #to say at the end of it that I have downloaded all 
}

setdir()
{
    #set range download
    echo "The aim is to be able to download ALL IN SET RANGE thumbnais"
 
    curl -s "https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152" > setrandir.txt        #writting the html text into the rand.txt file
    cat setrandir.txt | grep -Eo '(http|https)://[^"]+' | grep ".jpg" | sed 's/.*\///' | sed -e 's/^DSC0//' | sed -e 's/.jpg$//' > setrandirlist.txt      
                                            #while looking at the rand.txt file, stip out all the html, look at everything that has the .jpg on the end
                                            #using sed - delete everything that starts with DS0 and ends with .jpg save it to randlist.txt
    awk 'BEGIN {FS="^"; print "\n"}{ ORS=" "; print "\t"}{print ; if(++onr%10 == 0) print "\n"}' setrandirlist.txt #while using the file seperate, print that on a new line
                                                                                                                # Output record separator prints a space between the output, and tab's then to the righy
                                                                                                                #test if the variables are more than 10, if they are, start the 11th on a new line (only 10 in a row
    echo -e "\n\nProgram Finished"  #printed a new line for visual purposes
}


menuPresent()               #the menu function
{
MenuOption='Please enter your choice: '         #Displaying the output choice for user
choices=("Download specific file" "Download all files" "Download files in range" "Download set number of times" "Quit")     #The choices avaialbe for the user to choose from is between the ()
select opt in "${choices[@]}"               #the users input will determin what the part of the case study will go to
do
    case $opt in
        "Download specific file")               #if the first option is chosen, the specific download fucntion will start, a text will just print to say what the user has chosen
            echo "Option 1 was chosen, a specific thumbnail download."
            specificDown
            ;;                                              # the ;; is to stop this part of the case statement
        "Download all files")                   #if the second option is chosen, the all download fucntion will start, a text will just print to say what the user has chosen
            echo "Option 2 was chosen, all thumbnail download."
            allDown
            ;;                                               # the ;; is to stop this part of the case statement
        "Download files in range")               #if the third option is chosen, the range download fucntion will start, a text will just print to say what the user has chosen
            echo "Option 3 was chosen, download thumbnail in range."
            randir
            ;;                                                # the ;; is to stop this part of the case statement
        "Download set number of times")          #if the fourth option is chosen, the set range download fucntion will start, a text will just print to say what the user has chosen
            echo "Option 4 was chosen, download thumbnail in set range."
            setdir
            ;;                                               # the ;; is to stop this part of the case statement
        "Quit")
            break                               #if the user wants to leave the program
            ;;                                                # the ;; is to stop this part of the case statement
        *) echo "invalid option $REPLY";;       #if anything other han specified output is given, it will through an error saying it is invalid
    esac
done
}

menuPresent             #calling menu function