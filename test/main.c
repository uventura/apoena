#include "unity/unity.h"
#include <stdio.h>

#include "test_example.h"

void setUp(void)
{
}

void tearDown(void)
{
}

int main()
{
    UNITY_BEGIN();

    // TESTING EXAMPLE
    RUN_TEST(test_positive_numbers);

    return UNITY_END();
}
