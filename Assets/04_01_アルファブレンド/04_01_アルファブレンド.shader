Shader "Custom/04_01_アルファブレンド"
{
    Properties
    {
        _Color("Color", Color) = (1, 0, 0, 0.5)     // RGBA
        _Alpha("Alpha", Range(0, 1)) = 0.5          // スライダーで調整可能なα値
    }

    SubShader
    {
        Tags
        {
            "Queue" = "Transparent"                 // 半透明描画キュー
            "RenderType" = "Transparent"
        }
        Blend SrcAlpha OneMinusSrcAlpha             // αブレンド設定
        ZWrite Off                                  // 背景が透けるようにする
        Cull Off                                   // 両面描画（必要に応じて）

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
            };

            float4 _Color;
            float _Alpha;

            v2f vert(appdata v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                // α値をスライダーで指定された値に変更
                fixed4 o = _Color;
                o.a = _Alpha;
                return o;
            }
            ENDCG
        }
    }
}
