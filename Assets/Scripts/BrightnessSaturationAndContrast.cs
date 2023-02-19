
using UnityEngine;

public class BrightnessSaturationAndContrast : BasePostEffect
{
    [Range(0.0f, 3.0f)]
    public float brightness = 1.0f;

    [Range(0.0f, 3.0f)]
    public float saturation = 1.0f;

    [Range(0.0f, 3.0f)]
    public float contrast = 1.0f;

    public Shader briSatConShader;
    private Material briSatConMaterial;
    public Material material
    {
        get
        {
            if (briSatConMaterial == null)
                briSatConMaterial = CheckShaderAndCreatMaterial(briSatConShader, briSatConMaterial);
            return briSatConMaterial;
        }
    }

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (material != null)
        {
            material.SetFloat("_Brightness", brightness);
            material.SetFloat("_Saturation", saturation);
            material.SetFloat("_Contrast", contrast);

            Graphics.Blit(src, dest, material);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }
}