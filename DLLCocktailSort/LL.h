//Alan Reisenauer
//Student ID: 2001751827
//CS302 - Fall 23
//Assignment 1
//Cocktail Shaker sort

#ifndef ASSIGNMENT1_FALL23_LL_H
#define ASSIGNMENT1_FALL23_LL_H

template <typename T>
class LL
{
// contents of each node
    struct Node
    {
        T data;
        Node* prev;
        Node* next;
    };
// iterator class to allow access of each node in main
public:
    class Iterator
    {
    public:
        friend class LL;
        Iterator ();
        Iterator(Node *);
        T operator *() const;
        const Iterator& operator ++(int);
        const Iterator& operator --(int);
        bool operator ==( const Iterator &) const;
        bool operator !=( const Iterator &) const;
    private:
        Node* current;
    };
    LL();
    LL(const LL <T>&);
    const LL <T>& operator =(const LL<T>&);
    ~LL();
    void headInsert(const T&);
    void tailInsert(const T&);
    Iterator begin () const;
    Iterator end() const;
    void swapNodes(Iterator&, Iterator &);
private:
    Node* head;
    Node* tail;
};


//---------------------------------------------
//functions written out
//---------------------------------------------
//Default constructor that sets current with NULL
template <typename T> LL<T>::Iterator::Iterator()
{
    current = nullptr;
}

// Constructor sets current = ptr
template <typename T> LL<T>::Iterator::Iterator(Node* ptr)
{
    current = ptr;
}

//overloaded the returns the data field of the node the iterator points to
template <typename T> T LL<T>::Iterator::operator*() const
{
    return this->current->data;
}

//postfix ++ operator that moves the iterator object one node to the right
template <typename T>
const typename LL<T>::Iterator& LL<T>::Iterator::operator++(int)
{
    current = current->next;
    return *this;
}

//postfix -- operator that moves the iterator object one node to the left
template <typename T> const typename LL<T>::Iterator& LL<T>::Iterator::operator--(int)
{
    current = current->prev;
    return *this;
}

// Comparison operator, compares if the *this Iterator and the rhs Iterator point
// to the same node, if they do return true, if not return false
template <typename T> bool LL<T>::Iterator::operator==(const Iterator& rhs) const
{
    if (this->current == rhs.current) {
        return true;
    } else return false;
}

// Comparison operator, compares the *this Iterator and the rhs Iterator point to
// a different node, if they point to a different node, return true else return false
template <typename T> bool LL<T>::Iterator::operator!=(const Iterator& rhs) const
{
    if (this->current != rhs.current)
        return true;
    else return false;
}

//default constructor, assign the head and tail with NULL
template <typename T> LL<T>::LL()
{
    head = nullptr;
    tail = nullptr;
}

//Deep copy constructor, deep copies the copy
// object into the *this object
template <typename T> LL<T>::LL(const LL<T>& copy) {
    //return null if the original is null
    if ((copy.head == nullptr) && (copy.tail == nullptr)) {
        head = nullptr;
        return;
    }
    //set head to the beginning of the copy
    head = new Node;
    head->prev = nullptr;
    head->data = copy.head->data;
    head->next = copy.head->next;
    //create a current marker
    Node* mark1 = head;
    Node* mark2 = copy.head->next;

    //loop through to copy all the elements
    while(mark2 != nullptr)
    {
        //move the pointers and assign them
        mark1->next = mark2;
        mark1->next->data = mark2->data;
        mark1->next->prev = mark1;
        mark1 = mark1->next;
        mark2 = mark2->next;
    }
    tail = mark1;
}

//deep copy assignment operator,
// deep copies the rhs object into the *this object, make sure you deallocate
// the *this object first before performing the deep copy, also check the self
//assignment, then return *this at the end
template <typename T>
const LL<T>&LL <T>::operator=(const LL<T>& rhs)
        {
            //handeling self assignment
            if (this == &rhs)
            {
                return *this;
            }

            //deallocate this LL
            while(head != nullptr)
            {
                Node* temp = head;
                head = head->next;
                delete temp;
            }

            //return null if the original is null
            if (rhs.head == nullptr) {
                head = nullptr;
                tail = nullptr;
                return *this;
            }
            //set head to the beginning of the copy
            head = new Node;
            head->data = rhs.head->data;
            head->next = rhs.head->next;
            //create a current marker
            Node* mark1 = head;
            Node* mark2 = rhs.head->next;

            //loop through to copy all the elements
            while(mark2 != nullptr)
            {
                //move the pointers and assign them
                mark1->next = mark2;
                mark1->next->data = mark2->data;
                mark1->next->prev = mark1;
                mark1 = mark1->next;
                mark2 = mark2->next;
            }
            tail = mark1;

            return *this;
        }

// destructor, deallocates the entire linked list
template <typename T> LL<T>::~LL()
{
    //deleting from head to tail
    while(head != nullptr)
    {
        Node* temp = head;
        head = head->next;
        delete temp;
    }
}

//Insert a new node to the front of the linked list and this node's data
//field must contain the contents of the item parameter
template <typename T> void LL<T>::headInsert(const T& item) {

    //create new temp node to insert the item
    Node *temp = new Node;

    //check if empty LL
    if ((head == nullptr) && (tail == nullptr)) {
        head = new Node;
        //create node in list for copy
        head->data = item;
        head->prev = nullptr;
        head->next = nullptr;
        //setup tail stuff
        tail = head;
    } else {
        // temp gets the item's data
        temp->data = item;
        //re-assign the pointers
        temp->next = head;
        head->prev = temp;
        temp->prev = nullptr;
        head = temp;
    }
}

//Insert a new node to the back of the linked list and this
// nodes data field must contain the contents in the item parameter
template <typename T> void LL<T>::tailInsert(const T& item)
{
    //create new temp node to insert the item
    Node *temp = new Node;

    //check if empty LL
    if ((head == nullptr) && (tail == nullptr)) {
        tail = new Node;
        //create node in list for copy
        tail->data = item;
        tail->prev = nullptr;
        tail->next = nullptr;
        //setup tail stuff
        head = tail;
    } else {
        // temp gets the item's data
        temp->data = item;
        //re-assign the pointers
        temp->prev = tail;
        tail->next = temp;
        temp->next = nullptr;
        tail = temp;
    }
}

//returns an Iterator object whose current field
//contains this->head
template <typename T>
typename LL<T>::Iterator LL<T>::begin() const
{
    return this->head;
}

//returns an Iterator object whose current field
//contains this->tail
template <typename T>
typename LL<T>::Iterator LL<T>::end() const
{
    return this->tail;
}

//swap the location of the node it1.current
//with the location it2.current, you cannot just swap the data fields, you need to modify prev/next
//pointers to actually physically move the two nodes in the list, watch the supplemental video for a more
//detailed explanation
template <typename T> void LL<T>::swapNodes(Iterator& it1, Iterator& it2) {
    //creating pointers for i1 & i2
    Node* i1 = it1.current;
    Node* i2 = it2.current;
    //creates temps to be an intermediary for pointer assignments
    //left of IT1
    Node* i1_left = i1->prev;
    //right of IT2
    Node* i2_right = i2->next;


    //assignments
    //make i1_left to point to it2
    //if statement for if one of the items is a head
    if (i1_left != nullptr) {
        i1_left->next = i2;
    }
    //make it2 prev points to i1_left
    i2->prev = i1_left;
    //make it2 left of it1
    i2->next = i1;
    //make i2_right to point to i1
    //if statement for is one of the items is a tail
    if (i2_right != nullptr) {
        i2_right->prev = i1;
    }
    //reassign it1 next
    i1->next = i2_right;
    //make it1 to the right of it2
    i1->prev = i2;

    if (i1 == head)
        head = i2;
    if (i2 == tail)
        tail = i1;


    it1.current = i2;
    it2.current = i1;
}

#endif
