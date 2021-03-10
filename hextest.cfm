<cffunction name="RGBtoHex" hint="Converts RGB to HEX" returntype="string">
<cfargument name="rgb" required="yes" type="string">
<cfset hexList = "0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F">
<cfset tempHex = "">
<cfloop list=#rgb# index="j">
	<cfset hex = ((j - j MOD 16)/16) + 1>
	<cfset hex1 = (j MOD 16) + 1>
	<cfset hex = ListGetAt(hexList,hex)>
	<cfset hex1 = ListGetAt(hexList,hex1)>
	<cfset hex = "#hex##hex1#">
	<cfset tempHex = "#tempHex##hex#">
</cfloop>
<cfset tempHex = "###tempHex#">
<cfreturn tempHex>
</cffunction>
<cfscript>
/**
 * Convert a hexadecimal color into a RGB color value.
 * 
 * @param hexColor 	 6 character hexadecimal color value. 
 * @return Returns a string. 
 * @author Eric Carlisle (ericc@nc.rr.com) 
 * @version 1.0, November 6, 2001 
 */
function HextoRGB(hexColor){
  /* Strip out poundsigns. */
  Var tHexColor = replace(hexColor,'##','','ALL');
	
  /* Establish vairable for RGB color. */
  Var RGBlist='';
  Var RGPpart='';	

  /* Initialize i */
  Var i=0;

  /* Loop through each hex triplet */
  for (i=1; i lte 5; i=i+2){
    RGBpart = InputBaseN(mid(tHexColor,i,2),16);
    RGBlist = listAppend(RGBlist,RGBpart);
  }
  return RGBlist;
}
</cfscript>

