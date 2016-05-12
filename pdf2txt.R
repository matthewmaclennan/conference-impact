# download pdftotxt from 
# ftp://ftp.foolabs.com/pub/xpdf/xpdfbin-win-3.04.zip
# and extract to your program files folder

# here is a pdf for mining
pacifichem<-"C:\\Users\\dmmaclennan\\Desktop\\Matthew\\602457-dec-15-20-hono.pdf"


# set path to pdftotxt.exe and convert pdf to text
exe <- "C:\\Users\\dmmaclennan\\Desktop\\Matthew\\xpdfbin-win-3.04\\xpdfbin-win-3.04\\bin64\\pdftotext.exe"
system(paste("\"", exe, "\" \"", pacifichem, "\"", sep = ""), wait = F)

# get txt-file name and open it  
filetxt <- sub(".pdf", ".txt", pacifichem)
shell.exec(filetxt)

##################
#
#
#
#
#all page numbers
pall[grep("[0-9]{2,3}.+TECH$|TECH.+[0-9]{2,3}$",pall,perl=T)]
#All talk titles
pall[grep("^[0-9]+:[0-9]{2}.{3}[0-9]{1,3}\\.",pall,perl=T)]
#All sessions
pall[grep("^.+\\(#[0-9]{1,3}\\)$",pall,perl=T)]
#Page heading lines (ANYL)
grep("\\\f[0-9]{2}.{3}ANYL",pall,perl=T)
#Page heading lines (all topics)
pall[grep("\\\f[0-9]{2}.{3}[A-Z]{4}",pall,perl=T)]
#Start by marking the lines between pages. Within these boundaries,
#Find the sessions. For each session, find the presentation titles between.
#For each presentation title separate authors and presentation.
bob<-grep("\\\f[0-9]{2}.{3}[A-Z]{4}",pall,perl=T) #line markers for page boundaries
#scan per page for sessions
pallsess<-pall[bob[1]:bob[2]][grep("^.+\\(#[0-9]{1,3}\\)$",pall[bob[1]:bob[2]],perl=T)]
bob2<-grep("^.+\\(#[0-9]{1,3}\\)$",pall[bob[1]:bob[2]],perl=T) #pallsess grep
#session paragraph
pall[bob[1]:bob[2]][bob2[1]:bob2[2]-1]
#session talks
strsplit(paste0(pall[bob[1]:bob[2]][bob2[1]:bob2[2]],collapse=" "),"[0-9]+:[0-9]{2} . ")


#loop for within one page, for every page!

list2<-list()
for(j in 1:(length(bob)-1)){
bob2<-grep("^.+\\(#[0-9]{1,3}\\)$",pall[bob[j]:bob[j+1]],perl=T)

if(length(bob2)==0){

next

} else {

if(length(bob2)==1){

list1<-list()

list1[[1]]<-strsplit(paste0(pall[bob[j]:bob[j+1]][bob2[1]],collapse=" "),"[0-9]+:[0-9]{2} . ",perl=T)


} else {
list1<-list()
for(i in 1:(length(bob2)-1)){

list1[[i]]<-strsplit(paste0(pall[bob[j]:bob[j+1]][bob2[i]:bob2[i+1]-1],collapse=" "),"[0-9]+:[0-9]{2} . ",perl=T)
}
}
}
list2[[j]]<-list1
}

unlist2<-unlist(list2)
vector<-unlist(lapply(strsplit(unlist2,"[0-9]{1,3}\\. ",perl=T),function(x) x[2]))
#cleaned up vector 1
vector2<-unlist(regmatches(vector,gregexpr("^.+\\.(?= [A-Z]\\.)",vector,perl=T)))
#submit to tmpreproc
