% This function is just a multi-input wrapper for the beta-dist estimation

function Output = MultiWrapper(Input)

MyCount = size(Input,2);
Output = nan(1,MyCount);
for z = 1:MyCount,
    Output(z) = ObjectiveFuncOpenCL(Input(:,z));
end
