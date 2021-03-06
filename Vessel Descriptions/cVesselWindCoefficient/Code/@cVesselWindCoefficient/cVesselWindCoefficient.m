classdef cVesselWindCoefficient < cModelID
    %CVESSELWINDCOEFFICIENT Wind resistance coefficents for ships.
    %   Detailed explanation goes here
    
    properties
        
        Direction double = [];
        Coefficient double = [];
    end
    
    properties(Hidden, Constant)
        
        ModelTable = 'WindCoefficientModel';
        ValueTable = {'WindCoefficientModelvalue'};
        ModelField = {'Wind_Coefficient_Model_Id'};
        DataProperty = {'Direction',...
                        'Coefficient',...
                        'Name',...
                        'Description',...
                        'Wind_Coefficient_Model_Id',...
                        'Deleted'};
        ValueObject = {};
        OtherTable = {};
        TableIdentifier = 'Wind_Coefficient_Model_Id';
        NameAlias = '';
        OtherTableIdentifier = '';
        EmptyIgnore = {'Deleted'};
    end
    
    properties(Hidden)
        
        Wind_Coefficient_Model_Id;
    end
    
    methods
    
       function obj = cVesselWindCoefficient(varargin)
           
           obj = obj@cModelID(varargin{:});
       end
       
       function prop = properties(~)
           
           prop = {
                    'Direction'
                    'Coefficient'
                    'Model_ID'
                    'Name'
                    'Deleted'
                                };
       end
       
       function out = disp(obj)
       % disp Display selected properties only
           
           props = properties(obj);
           numObj = numel(obj);
           for oi = 1:numObj
               
               currPropNameVal = cell(numel(props), 2);
               for pi = 1:numel(props)
                   
                   currPropName = props{pi};
                   currPropVal = obj(oi).(currPropName);
                   currPropNameVal{pi, 1} = currPropName;
                   currPropNameVal{pi, 2} = currPropVal;
               end
               
               currPropNameVal = currPropNameVal';
               out(oi) = struct(currPropNameVal{:});
           end
           
           disp(out);
       end
       
       function obj = mirrorAlong180(obj)

           for oi = 1:numel(obj)

               % Error if empty, values above 180
               dir1 = obj(oi).Direction;
               if any(dir1 > 180)

                  errid = 'cVWC:ValuesExceed180';
                  errmsg = 'Direction values cannot exceed 180 degrees';
                  error(errid, errmsg);
               end

               % Ensure that data lies between 0 and 180
               dir1 = cVesselWindCoefficient.shiftBetween0And360(dir1);

               % Extend to other side of the symmetry plane by taking from 360
               dir2 = 360 - dir1;
               includes180 = ismember(180, dir1);
               includes0 = ismember(0, dir1);
               coeffs = obj(oi).Coefficient;
               coeffs2 = coeffs;

               startIndex = length(dir2);
               if includes180
                   startIndex = length(dir2) - 1;
               end

               finalIndex = 1;
               if includes0
                   finalIndex = 2;
               end

               obj(oi).Direction = [dir1, dir2(startIndex:-1:finalIndex)];
               obj(oi).Coefficient = [coeffs, coeffs2(startIndex:-1:finalIndex)];
           end
       end
       
       function [obj, plotHandles] = plot(obj)
          
           plotHandles = plot(obj.Direction, obj.Coefficient);
           
       end
       
    end

    methods(Static)
        
        function angle = shiftBelow360(angle)
            
            angle = angle - 360;
        end
        
        function angle = shiftAbove0(angle)
            
            angle = 360 + angle;
        end
        
        function angle = shiftBetween0And360(angle)
            
            angle = cVesselWindCoefficient.shiftBelow360(angle);
            angle = cVesselWindCoefficient.shiftAbove0(angle);
        end
    end
    
    methods
        
        function obj = set.Direction(obj, dir)
            
            obj.Direction = dir(:)';
            
        end
        
        function obj = set.Coefficient(obj, coeff)
            
            obj.Coefficient = coeff(:)';
        end
        
        function id = get.Wind_Coefficient_Model_Id(obj)
            
            id = obj.Model_ID;
        end
        
    end
end