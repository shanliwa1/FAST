#ifndef FAST_TRIANGLE_RENDERER_HPP_
#define FAST_TRIANGLE_RENDERER_HPP_

#include "FAST/Data/Mesh.hpp"
#include "FAST/Data/Color.hpp"
#include "FAST/Visualization/Renderer.hpp"

namespace fast {

class FAST_EXPORT TriangleRenderer : public Renderer {
    FAST_OBJECT(TriangleRenderer)
    public:
        uint addInputConnection(DataPort::pointer port) override;
        uint addInputConnection(DataPort::pointer port, Color color, float opacity);
        void setDefaultOpacity(float opacity);
        /**
         * Enable/disable renderer of wireframe instead of filled polygons
         * @param wireframe
         */
        void setWireframe(bool wireframe);
        void setDefaultColor(Color color);
        void setDefaultSpecularReflection(float specularReflection);
        void setColor(uint inputNr, Color color);
        void setLabelColor(int label, Color color);
        void setOpacity(uint inputNr, float opacity);
        void setLineSize(int size);
    private:
        void draw() override;
        void draw2D(
                cl::Buffer PBO,
                uint width,
                uint height,
                Affine3f pixelToViewportTransform,
                float PBOspacing,
                Vector2f translation
        ) override;
        TriangleRenderer();

        std::unordered_map<uint, Color> mInputColors;
        std::unordered_map<int, Color> mLabelColors;
        std::unordered_map<uint, float> mInputOpacities;
        Color mDefaultColor;
        float mDefaultSpecularReflection;
        float mDefaultOpacity;
        int mLineSize;
        bool mWireframe;
};

} // namespace fast

#endif
