//Alan Reisenauer
//Student ID: 2001751827
//CS302 - Fall 23
//Assignment 1
//Cocktail Shaker sort

#include "LL.h"
#include <iostream>
#include <fstream>

using namespace std;

//const declarations
const string filePrompt = "Please input file name: ";
const string fileError = "Failed to open file.";

//function declaration
//template <typename T>
//void cocktailShakerSort(LL<T> &);

int main() {
    //declare the linked list & other variables needed
    //variables for data ingest
    LL<int> list;
    LL<int>::Iterator it, nil;
    string fileName;
    string line;
    int data;

    //variables for cocktail shaker sort
    bool swapped;
    typename LL<int>::Iterator swapPtrS;
    typename LL<int>::Iterator swapPtrE;
    //prompt for file name
    cout << filePrompt;
    cin >> fileName;

    //ingest the file contents into LL
    ifstream iFile(fileName);
    if (!iFile.is_open())
    {
        cout << fileError << endl;
        return 0;
    }

    //ingest information into List
    while (getline(iFile, line)) {
        if (!line.empty()) {
            data = stoi(line);
            list.tailInsert(data);
        }
    }
    //close the file
    iFile.close();


// cocktail shaker sort
// loop to do the sorting
    do {
        swapped = false;
        typename LL<int>::Iterator i, j;

        //special condition for the start to have i start at beginning
        if (swapPtrS == nullptr)
        {
            for (i = list.begin(), j = i; j != swapPtrE; j++) {
                if (*i > *j) {
                    list.swapNodes(i, j);
                    swapped = true;
                }
                i = j;
            }
        }
        // Iterate through the list from left to right
        else
        {
            for (i = swapPtrS, j = i; j != swapPtrE; j++) {
                if (*i > *j) {
                    list.swapNodes(i, j);
                    swapped = true;
                }
                i = j;
            }
        }

        if (swapPtrE == nullptr)
            swapPtrE = list.end();
        else
            swapPtrE--;

        // If no swaps were made, the list is sorted
        if (!swapped) break;

        //reset swapped status
        swapped = false;

        // Iterate through the list from right to left
        for (i = swapPtrE, j = i; i != swapPtrS; i--) {
            if (*i > *j) {
                list.swapNodes(i, j);
                swapped = true;
            }
            j = i;
        }

        // Adjust the start pointer
        //if null, make the start of list
        if (swapPtrS == nullptr)
            swapPtrS = list.begin();
        else
            swapPtrS++;

    } while (swapped);



    //print result
    for (it = list.begin(); it != nil; it++) {
        cout << *it << "\n";
    }
}
