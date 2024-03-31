#include <stdio.h>

void print_binary(unsigned int number, char buff[], int pos) {
    if (pos > 0) {
        print_binary(number >> 1, buff, --pos);
    }
    if (number & 1) buff[pos] = '1';
    else buff[pos] = '0';
}

int main(void) {
    unsigned int myname = 0xFAB10;

    char buffb[100] = "";
    print_binary(myname, buffb, sizeof(myname)*8);

    printf(
        "\
# My name\n\
hehe, can be represented in a hexadecimal form\n\
\n\
- Unsigned hexadecimal integer: `%X`\n\
- Binary: `%s`\n\
- Signed decimal integer: `%d`\n\
- Unsigned octal: `%o`\n\
", myname, buffb, myname, myname);

    printf("- Color: <div style=\"text-align: center;background-color: #FAB100;height: 5em;width: 5em;\">#FAB100</div>\n");
}