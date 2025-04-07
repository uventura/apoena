#include "unity/unity.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "lib/math/example.h"

void test_positive_numbers(void)
{
    int result = sum(3, 4);
    int expected = 7;

    TEST_ASSERT_EQUAL(result, expected);
}