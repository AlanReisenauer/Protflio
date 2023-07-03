/*
    Description: Box of Chocolates
                 being eaten
    Input: Seed for randomness
    Output: Lines said by Forest Gump
*/

#include <iostream>

using namespace std;

//creating super class
class chocolate {
public:
    virtual string whatAmI() = 0;

    virtual ~chocolate() = default;;
};

//creating derived class for dark chocolate
class dark : public chocolate {
    //creating virtual function for returning the title
    string whatAmI() { return "dark"; }

public:
    //special function for the comment to be printed
    void feelBitter() {
        cout << "Dark Chocolate: oof that was bitter!" << endl;
    }
};

class milk : public chocolate {
    //creating virtual function for returning the title
    string whatAmI() { return "milk"; }

public:
    //special function for the comment to be printed
    void feelSoft() {
        cout << "Milk Chocolate: Too Soft, no chocolate taste!" << endl;
    }
};

class hazelnut : public chocolate {
    //creating virtual function for returning the title
    string whatAmI() { return "hazelnut"; }

public:
    //special function for the comment to be printed
    void getAllergy() {
        cout << "Hazelnut Chocolate: I don't feel so good." << endl;
    }
};

class raspberry : public chocolate {
    //creating virtual function for returning the title
    string whatAmI() { return "raspberry"; }

public:
    //special function for the comment to be printed
    void telljoke() {
        cout << "Raspberry Chocolate: I don't always Raspberry,"
             << " but when I do, I Raspberry Pi" << endl;
    }
};

class white : public chocolate {
    //creating virtual function for returning the title
    string whatAmI() { return "white"; }

public:
    //special function for the comment to be printed
    void feelScammed() {
        cout << "White Chocolate: Is this even real chocolate?" << endl;
    }
};

class mint : public chocolate {
    //creating virtual function for returning the title
    string whatAmI() { return "mint"; }

public:
    //special function for the comment to be printed
    void feelInquisitive() {
        cout << "Mint Chocolate: Am I still eating chocolate"
             << " or am I brushing my teeth?" << endl;
    }
};

//creating class for the array that will hold the chocolates
class boxOfChocolates {
    //establishing the private variables
private:
    int boxLength;
    int boxWidth;
    chocolate ***box;
public:
    //default deconstructor
    ~boxOfChocolates();

    //default constructor
    explicit boxOfChocolates(int l = 6, int w = 5);

    //fill box function to assign allocated memory in the box
    void fillBox();

    //way of retrieving the chocolates
    bool takeChocolate();
};

//writing the constructor
boxOfChocolates::boxOfChocolates(int length,
                                 int width) {
    //initializing dimensions
    boxLength = length;
    boxWidth = width;

    //initializing the box pointer rows
    box = nullptr;
    box = new chocolate **[length];
    //initializing the box pointer width
    for (int i = 0; i < length; ++i) {
        box[i] = nullptr;
        box[i] = new chocolate *[width];
    }
    //calling fill box to assign flavors
    fillBox();
}

void boxOfChocolates::fillBox() {
    //initializing a number for
    //usage in the switch statement
    //looping to assign the chocolates
    for (int i = 0; i < boxLength; ++i) {
        //looping in the columns
        for (int j = 0; j < boxWidth; ++j) {
            //randomly determining the flavor
            switch ((rand() % 6)) {
                case 0:
                    box[i][j] = new dark;
                    break;
                case 1:
                    box[i][j] = new milk;
                    break;
                case 2:
                    box[i][j] = new hazelnut;
                    break;
                case 3:
                    box[i][j] = new raspberry;
                    break;
                case 4:
                    box[i][j] = new white;
                    break;
                case 5:
                    box[i][j] = new mint;
                    break;
                default:
                    continue;
            }
        }
    }
}

//take chocolate function to find
//out what chocolate is in that spot
bool boxOfChocolates::takeChocolate() {
    //initializing and creating the
    //way to find out the random location
    int l = rand() % boxLength;
    int w = rand() % boxWidth;
    bool output = false;
    chocolate *cobj = box[l][w];
    //determine if spot is empty
    if (cobj == nullptr) {
        //if there wasn't a chocolate, return false
        output = false;
    } else {
        //equality check for the string
        if (cobj->whatAmI() == "dark") {
            //downcast the pointer
            dark *dobj = dynamic_cast<dark *>(cobj);
            //call special function for flavor
            dobj->feelBitter();
        }
        if (cobj->whatAmI() == "milk") {
            //downcast the pointer
            milk *mobj = dynamic_cast<milk *>(cobj);
            //call special function for flavor
            mobj->feelSoft();
        }

        if (cobj->whatAmI() == "hazelnut") {
            //downcast the pointer
            hazelnut *hobj = dynamic_cast<hazelnut *>(cobj);
            //call special function for flavor
            hobj->getAllergy();
        }

        if (cobj->whatAmI() == "raspberry") {
            //downcast the pointer
            raspberry *robj = dynamic_cast<raspberry *>(cobj);
            //call special function for flavor
            robj->telljoke();
        }

        if (cobj->whatAmI() == "white") {
            //downcast the pointer
            white *wobj = dynamic_cast<white *>(cobj);
            //call special function for flavor
            wobj->feelScammed();
        }

        if (cobj->whatAmI() == "mint") {
            //downcast the pointer
            mint *mobj = dynamic_cast<mint *>(cobj);
            //call special function for flavor
            mobj->feelInquisitive();
        }
        //delete the spot where the chocolate was
        delete box[l][w];
        //set that spot to null
        box[l][w] = nullptr;
        //return that there was a chocolate there
        output = true;
    }
    return output;
}

boxOfChocolates::~boxOfChocolates() {
    //deallocating based on length of the box
    for (int i = 0; i < boxLength; i++) {
        //deallocating based on width of the box
        for (int j = 0; j < boxWidth; j++) {
            //test if null, if not, delete
            if (box[i][j] != nullptr)
                delete box[i][j];
        }
        //delete after the array is full of null
        delete[] box[i];
    }
    //delete after completely full of null
    delete[] box;
}

int main(int argc, char *argv[]) {
    //declaring variables
    boxOfChocolates bobj;
    //testing the command line is correct
    if (argc != 2) {
        cout << "Enter seed as argument: ./a.out 42" << endl;
        return 0;
    }

    //setting the seed for rand function
    srand(stoi(string(argv[1])));

    //giving intro from Forest
    cout << "\"My mom always said life was like a box of chocolates."
            " You never know what you're\n"
            "gonna get.\" - Forrest Gump" << endl;
    //taking chocolates until one is
    //met that has already been taken
    do {
        bobj.takeChocolate();
    } while (bobj.takeChocolate() == true);

    return 0;
}
