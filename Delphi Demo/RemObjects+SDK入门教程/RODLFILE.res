        ��  ��                  �  0   ��
 R O D L F I L E                     <Library Name="TestLibrary" UID="{D221B0BC-B766-4A8C-A796-487491EA699D}" Documentation="">
   <Services>
      <Service Name="TestService" UID="{9A8ED8CD-91AD-4036-BC80-30AD94C5B43E}">
        <Interfaces>
           <Interface Name="Default" UID="{4D1B4633-0779-410F-B078-0D05BB284EC2}" Documentation="Service TestService. This service has been automatically generated using the RODL template you can find in the Templates directory.">
      <Operations>
         <Operation Name="Sum" UID="{7C234614-CE90-40E0-9ADE-439E874A1D62}" Documentation="">
      <Parameters>
         <Parameter Name="A" DataType="Integer" Flag="In" />
         <Parameter Name="B" DataType="Integer" Flag="In" />
         <Parameter Name="Result" DataType="Integer" Flag="Result" />
      </Parameters>
         </Operation>
         <Operation Name="GetServerTime" UID="{3FF0A2DE-47F0-47BC-9171-0943A750849B}" Documentation="">
      <Parameters>
         <Parameter Name="Result" DataType="DateTime" Flag="Result" />
      </Parameters>
         </Operation>
      </Operations>

           </Interface> 
        </Interfaces>
      </Service>
   </Services>
</Library>
