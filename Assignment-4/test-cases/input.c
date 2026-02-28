int gcd(int a, int b) {
    if (b == 0)
        return a;
    else
        return gcd(b, a % b);
}

int main() {
    int x, y, result;
    
    x = 48;
    y = 18;
    
    result = gcd(x, y);
    printf(result);
    
    return 0;
}
