using System;
using UnityEngine;
using UnityEngine.EventSystems;

namespace YouYou
{
    public class UIEventListener : MonoBehaviour, IPointerClickHandler
    {
        public Action onClick;

        public void OnPointerClick(PointerEventData eventData)
        {
            if (onClick != null) onClick();
        }
    }
}
