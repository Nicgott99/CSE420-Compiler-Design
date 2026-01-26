/*
 * Test Case 3: Complex Nested Scopes
 * Tests: Multiple levels of nested if statements, variable shadowing, scope management
 */

int func() {

    int a;

    if (a>1){
        float a;

        if (a>1) {
            int a;

             if (a>1) {
                float a;

                if (a>1) {
                    int a;

                    if (a>1) {
                        float a;
                    }
                }
             }
        }
    }
}