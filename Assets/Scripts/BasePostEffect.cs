using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode, RequireComponent(typeof(Camera))]
public abstract class BasePostEffect : MonoBehaviour
{
    private void Start()
    {
        CheckResource();
    }

    private void CheckResource()
    {
        if (!CheckSupport())
        {
            NotSupport();
        }
    }

    private void NotSupport()
    {
        Debug.LogError("不支持该后处理.");
    }

    private bool CheckSupport()
    {
        //SystemInfo.supportsImageEffects || !SystemInfo.supportsRenderTextures always true
        return true;
    }

    protected virtual Material CheckShaderAndCreatMaterial(Shader shader, Material material)
    {
        if (shader == null)
        {
            return null;
        }

        if (!shader.isSupported)
        {
            return null;
        }

        if (material && material.shader == shader)
        {
            return material;
        }

        material = new Material(shader);
        material.hideFlags = HideFlags.DontSave;
        return material;
    }
}
