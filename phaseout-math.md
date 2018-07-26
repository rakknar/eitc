Suppose the max bonus is $300K pesos, which begins being withdrawn at an income of $800K and vanishes completely by $1.4M. Then the slope of that last section is (1400 - 1100)/(1400 - 800) = 0.5, implying a marginal tax rate of 50%.

The EITC in the US phases out with a marginal tax rate of 21%. To phase this out at that rate we would need slope = 0.79. Let E(nd) = the pre-EITC income level at which it phases out completely, I = the level at which it starts, and B = $300K = the maximum EITC bonus. Then we need

(E - (I+B)) / (E - I) = 0.79
(E - I - B) = 0.79 * (E - I)
            = 0.79 E - 0.79 I
0.21 E = 0.21 I + B
E = I + B / 0.21

If I = $800K and B = $300K, then the phase out would be reached after $2.2M!

Prelude> f i b = i + b / 0.21
Prelude> f 800 300
2228.5714285714284
Prelude> 
