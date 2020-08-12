#include <iostream>
#include <string>

#include "endianness.h"

std::string solution::endianness() 
{
    int n = 1;
    std::string endian;
    // little endian if true
    // For a 32 bit machine, n in the memory will be 
    // 0x01 0x00 0x00 0x00
    // where as for big endian
    // 0x0 0x00 0x00 0x01
    if(*(char *)&n == 1)
    {
        endian = "little";
    }
    else
    {
        endian = "big";
    }

    return endian;
}

int main()
{
    solution a;
    std::string endian = a.endianness();
    std::cout<<"Endianness is: " << endian <<std::endl;

}
