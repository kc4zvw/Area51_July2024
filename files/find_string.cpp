//
// $Id: find_string.cpp,v 0.2 2021/06/11 17:46:27 kc4zvw Exp kc4zvw $
//

#include <iostream>
#include <stdio.h>
#include <string.h>
#include <cstring>
#include <fstream>
#include <cstdio>

#define FILENAME "haystack.html"
#define MAXSTR 300

using namespace std;

/* function prototypes */
void zeroArray(char *a);

int main()
{
	ifstream infile;

	bool inBody = false;
	bool inForm = false;
	char answer[40];
	char result[40];
	string aline, str;
	string str1 = "<body";

	infile.open(FILENAME, ios::in);

	while (getline(infile, aline)) {

		str = aline;

	    // Find first occurrence of "<body "
	    size_t found = aline.find(str1);
	    if (found != string::npos) {
			inBody = true;
	        //cout << "First occurrence is " << found << endl;
		}
  
	    // Find next occurrence of "<form ". 
	    char arr[] = "<form ";
	    size_t found2 = str.find(arr, found + 1);
	    if (found2 != string::npos) {
			inForm = true;
	        //cout << "Second occurrence is " << found2 << endl;
		}
 
	    // Find next occurrence of "name=". Note here we pass "name=" as C style string.
	    char arr3[] = "name=";
	    size_t found3 = str.find(arr3, found2 + 1);
	    if (inBody && inForm && found3 != string::npos) {
	        //cout << "Third occurrence is " << found3 << endl;
			break;

		}
	}

	//cout << str << endl;

    const char searchStr1[15] = "name=";
    const char searchStr2[15] = "value=";
    const char searchStr3[15] = "autocomplete=";

	char *result1, *result2, *result3, *result4;
    char ans1[MAXSTR];
    char ans2[MAXSTR];
    char ans3[MAXSTR];

    /* This function returns the pointer of the first occurrence
     * of the given string (i.e. searchString)
     */

	strcpy(ans3, str.c_str()); 

    result1 = strstr(ans3, searchStr1);			// looking for first name=
    result2 = strstr(result1 + 1, searchStr1);	// looking for second name=
    result3 = strstr(result2 + 1, searchStr2);	// looking for value=
    result4 = strstr(result3 + 1, searchStr3);	// looking for "autocomplete=

    //cout << "The substring : " << result1 << endl;
    cout << "The substring : " << result2 << endl;
    cout << "The substring : " << result3 << endl;
    //cout << "The substring : " << result4 << endl;
    cout << endl;

	zeroArray(ans1);
	zeroArray(ans2);
    strncpy(ans1, result2 + 6, strlen(result2) - strlen(result3) - 8);
    strncpy(ans2, result3 + 7, strlen(result3) - strlen(result4) - 9);

    puts(ans1);
    puts(ans2);

	infile.close();

	return 0;
}

void zeroArray(char *a)
{
	for (int i = 0; i < MAXSTR; i++) {
		a[i] = (char) NULL;
	}
}

/* End of File */
