classdef tMatrixLibrary < matlab.perftest.TestCase
    
    properties(TestParameter)
        TestMatrix = struct('midSize', magic(600),...
            'largeSize', magic(1000));
    end
    
    methods(Test)
        function testSum(testCase, TestMatrix)
            matrix_sum(TestMatrix);
        end
        
        function testMean(testCase, TestMatrix)
            matrix_mean(TestMatrix);
        end
        
        function testEig(testCase, TestMatrix)
            
            testCase.assertReturnsTrue(@() size(TestMatrix,1) == size(TestMatrix,2), ...
                'Eig only works on square matrix');
            testCase.startMeasuring;
            matrix_eig(TestMatrix);
            testCase.stopMeasuring;
            
        end
    end
end

