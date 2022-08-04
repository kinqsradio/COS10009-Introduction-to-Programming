#include <stdio.h>
#include <string.h>
#include "terminal_user_input.h"

#define LOOP_COUNT 60

void print_silly_name(my_string name) 
{
  int index;
  printf("Your name %s is a ",name.str);
  for (index = 0 ;index < LOOP_COUNT;index++) 
  {
    printf(" silly ");
  }
  printf("name!");
}

int main()
{
  my_string name;
 
  name = read_string("What is your name? ");  

  // Move the following code into a procedure
  // ie:  void print_silly_name(my_string name)

  if (strcmp(name.str,"Kerrie") == 0) 
  {
    printf("Your name is an AWESOME name!");
  } else {
    print_silly_name(name);
  }
  return 0;
}
