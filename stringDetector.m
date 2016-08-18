%%This Function maps each chacter found to there specific value.

function string = stringDetector(a)

str = '';
switch a
    case 1
        str = '1';
    case 2
        str = '2';
    case 3
        str = '3';
    case 4
        str = '4';
    case 5
        str = '5';
    case 6
        str = '6';
    case 7
        str = '7';
    case 8
        str = '8';
    case 9
        str = '9';
    case 10
        str = '0';
    case 11
        str = 'Baa';
    case 12
        str = 'Cha';
    case 13
        str = 'Ba';
    case 14
        str = 'Pa';        
    case 15
        str = 'Kha';
    case 16
        str = 'Ja';
    otherwise
        str = '';
end
string = str;
end