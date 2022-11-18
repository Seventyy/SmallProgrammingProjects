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

int inputChoiceId(int _max, string _message)
{
    cout << _message;
    string input;
    try
    {
        getline(cin,input);
        for (int i = 1; i <= _max; i++)
        {
            if (input == to_string(i))
            {
                return i;
            }
        }
        throw 0;
    }
    catch (int ex)
    {
        cout << "No valid operation choosen, please use nubmers from 1 to " << _max << '\n';
        return inputChoiceId(_max, _message);
    }
}

char inputValidSymbol(string _message)
{
    cout << _message;
    string input;
    try
    {
        getline(cin,input);
        if (input.size() != 1 || input[0] == ' ')
        {
            throw 0;
        }
        return input[0];
    }
    catch (int ex)
    {
        cout << "Input has to consist of a singular character\n";
        return inputValidSymbol(_message);
    }
}

int inputValidScore(string _message)
{
    cout << _message;
    string input;
    try
    {
        getline(cin,input);
        if (!((input[0] >= 48 && input[0] <= 57) || input[0] == '-'))
        {
            throw 0;
        }
        for (int i = 1; i < input.size(); i++)
        {
            if (!((input[i] >= 48 && input[i] <= 57)))
            {
                throw 0;
            }
        }
        return stoi(input);
        throw 1;
    }
    catch (int ex)
    {
        cout << "Score has to be a whole number\n";
    }
    catch (out_of_range ex)
    {
        cout << "Exeeded numerical limits, score must exist in range from -2147483648 to 2147483647\n";
    }
    return inputValidScore(_message);
}

string inputValidName(string _message)
{
    cout << _message;
    string input;
    try
    {
        getline(cin,input);
        for (int i = 0; i < input.size(); i++)
        {
            if (input[i]==' ')
            {
                throw 0;
            }
        }
        return input;
    }
    catch (int ex)
    {
        cout << "Name cannot contain spaces\n";
    }
    return inputValidName(_message);
}

bool program()
{
     string input_filename;
    fstream input_file;

    vector<Player> players;

    // 2 geting file name
    while (true)
    {
        string line;
        cout << "Enter file name: ";
        try
        {
            getline(cin, input_filename);
            input_file.open(input_filename, ios::in);
            if (!input_file) 
                throw 1;

            int space_amount = 0;
            for (int i = 0; getline(input_file, line); i++)
            {
                int j = 0;
                for (; j < line.size(); j++)
                {
                    if (line[j] == ' ')
                        space_amount++;
                    if (space_amount == 2)
                        break;
                }
                j++;
                if (!((line[j] >= 48 && line[j] <= 57) || line[j] == '-'))
                    throw 0;
                for (j++; j < line.size(); j++)
                {
                    if (!((line[j] >= 48 && line[j] <= 57)))
                    {
                        throw 0;
                    }
                }
                space_amount = 0;
            }
            input_file.close();
            input_file.open(input_filename, ios::in);
            break;
        }
        catch (int ex)
        {
            switch (ex)
            {
            case 0:
                cout << "File not found\n\n";
                break;
            default:
                cout
                    << "Data in the file has incorret format\n"
                    << "Error in line " << ex << ": \"" << line << "\"\n"
                    << "1. Choose diffrent file\n"
                    << "2. Exit program\n";

                if (bool(inputChoiceId(2, "Enter number of desired operation: ") - 1))
                    return 0;
                input_file.close();
            }
        }
    }

    // 3, 4 reading from file
    string line;
    int line_pointer = 0;
    for (int i = 0; getline(input_file, line); i++)
    {
        string name;
        char symbol;
        int score;

        for (line_pointer = 0; line[line_pointer] != ' '; line_pointer++)
            name.push_back(line[line_pointer]);
        symbol = line[line_pointer + 1];
        try
        {
            score = stoi(line.substr(line_pointer + 2, line.size() - line_pointer - 2));
        }
        catch (...)
        {
            cout << "Problem with a the file, score exeeding limits\n";
            program();
            return 0;
        }
        Player player(name, symbol, score);
        players.push_back(player);
    }
    input_file.close();

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
            cout << "Enter name of the output file: ";
            getline(cin, output_filename);
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
        catch (out_of_range ex)
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
    return 1;
}


int main() 
{
   program();
}
