local ModelLighting = {}


-- Создаёт шейдер направленного света.
function ModelLighting.new()
  return lovr.graphics.newShader(
    'unlit',

    [[
      uniform vec3 sunDirection;
      uniform float ambientLight;
      uniform float sunStrength;

      vec4 lovrmain()
      {
        vec4 baseColor =
          Color *
          getPixel(
            ColorTexture,
            UV
          );

        if (
          baseColor.a <
          Material.alphaCutoff
        ) {
          discard;
        }

        vec3 normal =
          normalize(Normal);

        vec3 lightDirection =
          normalize(sunDirection);

        float diffuse =
          max(
            dot(
              normal,
              lightDirection
            ),
            0.0
          );

        float brightness =
          ambientLight +
          diffuse * sunStrength;

        brightness =
          clamp(
            brightness,
            0.0,
            1.5
          );

        return vec4(
          baseColor.rgb *
          brightness,

          baseColor.a
        );
      }
    ]]
  )
end


return ModelLighting