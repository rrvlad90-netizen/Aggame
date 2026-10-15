models/players/fritzkrieg/fritz_fx
{
     
     cull disable

        {
                map models/players/fritzkrieg/fritz_fx2.tga
                //tcMod scale 2 2
                tcGen environment
                rgbGen lightingdiffuse
        }
        {
                map models/players/fritzkrieg/fritz_fx.tga
                blendFunc blend
                rgbGen lightingdiffuse
        }
}
models/players/fritzkrieg/fritz_c
{
	
	cull none
        //nopicmip
	{
		map models/players/fritzkrieg/fritz_c.tga
		alphaFunc GE128
		depthWrite
		rgbGen lightingdiffuse
	}
        
}
models/players/fritzkrieg/beam
{
     deformVertexes autoSprite2
     cull disable

        {
                map models/players/fritzkrieg/beam.tga
                Blendfunc Add
                rgbGen identity
        }
}
models/players/fritzkrieg/beam2
{
     deformVertexes autoSprite
     cull disable

        {
                map models/players/fritzkrieg/beam2.tga
                Blendfunc Add
                rgbGen identity
        }
}