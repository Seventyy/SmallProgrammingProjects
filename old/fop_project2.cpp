#include <iostream>
#include <fstream>
#include <string>
#include <vector>

using namespace std;

class Player
{
public:
    string name;
    char symbol;
    int score;

    void print(int _i)
    {
        cout
            << "Player " << _i + 1 << ":\n"
            << "Name: " << name << '\n'
            << "Symbol: " << symbol << '\n'
            << "Score: " << score << '\n' << '\n';
    }

    Player(string _name = "", char _symbol = 0, int _score = 0)
    {
        name = _name;
        symbol = _symbol;
        score = _score;
    }

};

string validateName(string _input)
{
    for (int i = 0; i < _input.size(); i++)
    {
        if (_input[i] == ' ')
        {
            throw 0;
        }
    }
    return _input;
}
string inputValidName(string _message)
{
    cout << _message;
    string input;
    try
    {
        getline(cin, input);
        return validateName(input);
    }
    catch (...)
    {
        cout << "Invalid input, name cannot contain spaces\n";
    }
    return inputValidName(_message);
}

char validateSymbol(string _input)
{
    if (_input.size() != 1 || _input[0] == ' ')
    {
        throw 0;
    }
    return _input[0];
}
char inputValidSymbol(string _message)
{
    cout << _message;
    string input;
    try
    {
        getline(cin, input);
        return validateSymbol(input);
    }
    catch (...)
    {
        cout << "Invalid input, symbol has to be singular character other then space\n";
    }
    return inputValidSymbol(_message);
}

int validateScore(string _input)
{
    if (!((_input[0] >= '0' && _input[0] <= '9') || _input[0] == '-'))
    {
        throw 0;
    }
    for (int i = 1; i < _input.size(); i++)
    {
        if (!((_input[i] >= '0' && _input[i] <= '9')))
        {
            throw 0;
        }
    }
    return stoi(_input);
}
int inputValidScore(string _message)
{
    cout << _message;
    string input;
    try
    {
        getline(cin, input);
        return validateScore(input);
    }
    catch (...)
    {
        cout << "Invalid input, score has to be a whole number in range from -2147483648 to 2147483647\n";
    }
    return inputValidScore(_message);
}


int validateChoiseId(string _input, int _max)
{
    for (int i = 1; i <= _max; i++)
    {
        if (stoi(_input) == i)
        {
            return i;
        }
    }
    throw 0;
}
int inputChoiceId(int _max, string _message)
{
    cout << _message;
    string input;
    try
    {
        getline(cin, input);
        return validateChoiseId(input, _max);
    }
    catch (...)
    {
        cout << "No valid operation choosen, please use nubmers from 1 to " << _max << '\n';
        return inputChoiceId(_max, _message);
    }
}


int main()
{
    vector<Player> players;
    
    // 2 geting file name
    while (true)
    {
        string input_filename;
        fstream input_file;
        string line;
        vector<int> bad_line_indexes;
        vector<string> bad_line_contents;
        cout << "Enter file name: ";
        try
        {
            getline(cin, input_filename);
            input_file.open(input_filename, ios::in);
            if (!input_file)
                throw 1;

            // 3, 4 reading from file
            for (int i = 0, pointer1 = -1, pointer2 = -1; getline(input_file, line); i++)
            {
                try
                {
                    pointer1 = line.find(' ');
                    pointer2 = line.find(' ', pointer1 + 1);
                    if (pointer1 == -1 || pointer2 == -1 || line.find(' ', pointer2 + 1) != -1)
                        throw 0; // ex


                    string name = validateName(line.substr(0, pointer1)); 
                    char symbol = validateSymbol(line.substr(pointer1 + 1, pointer2 - pointer1 - 1));
                    int score = validateScore(line.substr(pointer2 + 1, line.length() - pointer2)); 

                    players.push_back(Player(name, symbol, score));

                }
                catch (...)
                {
                    bad_line_indexes.push_back(i);
                    bad_line_contents.push_back(line);
                }
            }
            cout << "Problem with data in lines:\n";
            for (int i=0;i<bad_line_indexes.size();i++)
            {
                cout << "#" << bad_line_indexes[i] << ": " << bad_line_contents[i] << '\n';
            }
            cout << "\nDo you wish to continue regardless?\n"
                << "1. Yes\n" 
                << "2. No\n";
            if (inputChoiceId(2, "Enter number of desired operation: ")==2)
            {
                input_file.close();
                continue;
            }
            input_file.close();
            break;
        }
        catch (...)
        {
            cout << "File not found\n\n";
            continue;
        }
        input_file.close();
        break;
    }


    while (true)
    {
        cout << '\n';
        // 5 printing
        for (int i = 0; i < players.size(); i++) { players[i].print(i); }

        // 6 manipulation operations
        cout
            << "1. Accept data\n"
            << "2. Change value\n"
            << "3. Add new player\n"
            << "4. Delete player\n";

        int operation = inputChoiceId(4, "Enter number of desired operation: ");
        cout << '\n';

        if (operation == 1)
        {
            cout << '\n';
            break;
        }
        switch (operation)
        {
        case 2:
        {
            int id = inputChoiceId(players.size(), "Enter player id: ");

            cout
                << "1. Name\n"
                << "2. Symbol\n"
                << "3. Score\n";
            int atribute = inputChoiceId(3, "Enter atribute id: ");

            switch (atribute)
            {
            case 1:
            {
                players[id - 1].name = inputValidName("Enter new name: ");
                break;
            }
            case 2:
            {
                players[id - 1].symbol = inputValidSymbol("Enter new symbol: ");
                break;
            }
            case 3:
            {
                players[id - 1].score = inputValidScore("Enter new score: ");
                break;
            }
            }
        }
        break;
        case 3:
        {
            string name;
            char symbol;
            int score;

            cout << "Enter atributes of the new player\n";

            name = inputValidName("Enter name: ");

            symbol = inputValidSymbol("Enter symbol: ");

            score = inputValidScore("Enter score: ");

            Player player(name, symbol, score);
            players.push_back(player);
        }
        break;
        case 4:
        {
            int id = inputChoiceId(players.size(), "Enter player id: ");

            players.erase(players.begin() + id - 1);
        }
        break;
        }
        cout << '\n';
    }


    // 7 output file
    ofstream output_file;
    string output_filename;
    while (true)
    {
        try
        {
            output_filename = inputValidName("Enter name of the output file: ");
            if (output_filename.substr(output_filename.size() - 4, 4) != ".txt")
            {
                for (int i = 0; i < output_filename.size(); i++)
                {
                    if (output_filename[i] == '.')
                        throw 0;
                }
                throw 1;
            }
            break;
        }
        catch (int ex)
        {
            switch (ex)
            {
            case 0:
                cout
                    << "File will not be saved as a \".txt\", do want to proceed anyway?\n"
                    << "1. Yes\n"
                    << "2. No\n";
                break;
            case 1:
                cout
                    << "File does not have an extention, do want to proceed anyway?\n"
                    << "1. Yes\n"
                    << "2. No\n";
                break;
            }
            if (!bool(inputChoiceId(2, "Enter number of desired operation: ") - 1))
                break;
        }
        catch (...)
        {
            cout << "Invalid file name, please do not use spaces\n";
            continue;
        }
    }
    output_file.open(output_filename, ios::out);

    for (int i = 0; i < players.size(); i++)
    {
        output_file
            << players[i].name << ' '
            << players[i].symbol << ' '
            << players[i].score << '\n';
    }
    output_file.close();
    return 0;
}
